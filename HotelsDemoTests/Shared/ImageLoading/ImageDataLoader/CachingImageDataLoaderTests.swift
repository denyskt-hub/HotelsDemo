//
//  CachingImageDataLoaderTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

final class CachingImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_init_doesNotMessageLoader() {
		let (_, loader, _) = makeSUT()

		XCTAssertTrue(loader.receivedMessages().isEmpty)
	}

	func test_init_doesNotMessageCache() {
		let (_, _, cache) = makeSUT()

		XCTAssertTrue(cache.receivedMessages().isEmpty)
	}

	func test_load_requestsDataFromLoader() {
		let url = anyURL()
		let (sut, loader, _) = makeSUT()

		sut.load(url: url) { _ in }

		XCTAssertEqual(loader.loadedURLs, [url])
	}

	func test_load_deliversErrorOnLoaderError() {
		let loaderError = anyNSError()
		let (sut, loader, _) = makeSUT()

		expect(sut, toLoad: .failure(loaderError), when: {
			loader.completeWith(.failure(loaderError))
		})
	}

	func test_load_deliversDataOnLoaderSuccess() {
		let nonEmptyData = Data("non-empty data".utf8)
		let (sut, loader, _) = makeSUT()

		expect(sut, toLoad: .success(nonEmptyData), when: {
			loader.completeWith(.success(nonEmptyData))
		})
	}

	func test_load_doesNotCacheOnLoaderError() {
		let (sut, loader, cache) = makeSUT()

		sut.load(url: anyURL()) { _ in }
		loader.completeWith(.failure(anyNSError()))

		XCTAssertTrue(cache.receivedMessages().isEmpty)
	}

	func test_load_cachesDataOnLoaderSuccess() {
		let (url, data) = (anyURL(), anyData())
		let (sut, loader, cache) = makeSUT()

		sut.load(url: url) { _ in }
		loader.completeWith(.success(data))

		XCTAssertEqual(cache.receivedMessages(), [.save(data, url.absoluteString)])
	}

	func test_load_ignoresCacheError() async throws {
		let data = anyData()
		let (sut, loader, cache) = makeSUT()

		expect(sut, toLoad: .success(data), when: {
			loader.completeWith(.success(data))
			cache.completeSaveWith(anyNSError())
		})
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: CachingImageDataLoader,
		loader: ImageDataLoaderSpy,
		cache: ImageDataCacheSpy
	) {
		let loader = ImageDataLoaderSpy()
		let cache = ImageDataCacheSpy()
		let sut = CachingImageDataLoader(
			loader: loader,
			cache: cache
		)
		return (sut, loader, cache)
	}
}
