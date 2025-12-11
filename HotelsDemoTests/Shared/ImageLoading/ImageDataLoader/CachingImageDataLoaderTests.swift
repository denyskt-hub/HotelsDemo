//
//  CachingImageDataLoaderTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

@MainActor
final class CachingImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_init_doesNotMessageLoader() {
		let (_, loader, _) = makeSUT()

		XCTAssertTrue(loader.receivedMessages().isEmpty)
	}

	func test_init_doesNotMessageCache() {
		let (_, _, cache) = makeSUT()

		XCTAssertTrue(cache.receivedMessages().isEmpty)
	}

	func test_load_requestsDataFromLoader() async throws {
		let url = anyURL()
		let (sut, loader, cache) = makeSUT()
		loader.stubWithData(anyData())
		cache.stubSaveResult(.success(()))

		try await sut.load(url: url)

		XCTAssertEqual(loader.loadedURLs, [url])
	}

	func test_load_deliversErrorOnLoaderError() async {
		let loaderError = anyNSError()
		let (sut, loader, _) = makeSUT()

		await expect(sut, toLoadWithError: loaderError, when: {
			loader.stubWithError(loaderError)
		})
	}

	func test_load_deliversDataOnLoaderSuccess() async {
		let nonEmptyData = Data("non-empty data".utf8)
		let (sut, loader, cache) = makeSUT()

		await expect(sut, toLoadData: nonEmptyData, when: {
			loader.stubWithData(nonEmptyData)
			cache.stubSaveResult(.success(()))
		})
	}

	func test_load_doesNotCacheOnLoaderError() async {
		let (sut, loader, cache) = makeSUT()
		loader.stubWithError(anyNSError())

		_ = try? await sut.load(url: anyURL())

		XCTAssertTrue(cache.receivedMessages().isEmpty)
	}

	func test_load_cachesDataOnLoaderSuccess() async throws {
		let (url, data) = (anyURL(), anyData())
		let (sut, loader, cache) = makeSUT()
		loader.stubWithData(data)
		cache.stubSaveResult(.success(()))

		try await sut.load(url: url)

		XCTAssertEqual(cache.receivedMessages(), [.save(data, url.absoluteString)])
	}

	func test_load_ignoresCacheError() async {
		let data = anyData()
		let (sut, loader, cache) = makeSUT()

		await expect(sut, toLoadData: data, when: {
			loader.stubWithData(data)
			cache.stubSaveResult(.failure(anyNSError()))
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
