//
//  PrefetchingImageDataLoaderTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 11/8/25.
//

import XCTest
import HotelsDemo

final class PrefetchingImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_init_doesNotMessageLoader() {
		let (_, loader, _) = makeSUT()

		XCTAssertTrue(loader.receivedMessages().isEmpty)
	}

	func test_init_doesNotMessageCache() {
		let (_, _, cache) = makeSUT()

		XCTAssertTrue(cache.receivedMessages().isEmpty)
	}

	func test_load_deliversDataFromCacheOnCacheSuccess() {
		let data = anyData()
		let (sut, _, cache) = makeSUT()

		expect(sut, toLoad: .success(data), when: {
			cache.completeDataWith(.success(data))
		})
	}

	func test_load_forwardsRequestToLoaderOnCacheErrorOrNoData() {
		let (sut, loader, cache) = makeSUT()

		let url1 = anyURL()
		sut.load(url: url1) { _ in }
		cache.completeDataWith(.failure(anyNSError()))
		XCTAssertEqual(loader.loadedURLs, [url1])

		let url2 = anyURL()
		sut.load(url: url2) { _ in }
		cache.completeDataWith(.success(.none))
		XCTAssertEqual(loader.loadedURLs, [url1, url2])
	}

	func test_load_deliversErrorOnLoaderErrorOnCacheError() {
		let loaderError = anyNSError()
		let (sut, loader, cache) = makeSUT()

		expect(sut, toLoad: .failure(loaderError), when: {
			cache.completeDataWith(.failure(anyNSError()))
			loader.completeWith(.failure(loaderError))
		})
	}

	func test_load_deliversDataFromLoaderOnCacheError() {
		let data = anyData()
		let (sut, loader, cache) = makeSUT()

		expect(sut, toLoad: .success(data), when: {
			cache.completeDataWith(.failure(anyNSError()))
			loader.completeWith(.success(data))
		})
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: PrefetchingImageDataLoader,
		loader: ImageDataLoaderSpy,
		cache: ImageDataCacheSpy
	) {
		let loader = ImageDataLoaderSpy()
		let cache = ImageDataCacheSpy()
		let sut = PrefetchingImageDataLoader(
			loader: loader,
			cache: cache
		)
		return (sut, loader, cache)
	}
}
