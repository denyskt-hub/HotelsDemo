//
//  ImageDataPrefetcherTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 11/8/25.
//

import XCTest
import HotelsDemo

final class ImageDataPrefetcherTests: XCTestCase {
	func test_prefetch_startsLoadingForEachURL() {
		let url1 = URL(string: "https://a.com")!
		let url2 = URL(string: "https://b.com")!
		let (sut, loader) = makeSUT()

		prefetch([url1, url2], sut: sut, loader: loader)

		XCTAssertEqual(loader.loadedURLs, [url1, url2])
	}

	func test_prefetch_doesNotStartDuplicateLoadsForSameURL() {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		prefetch([url, url], sut: sut, loader: loader)

		XCTAssertEqual(loader.loadedURLs, [url], "Should load only once")
	}

	func test_prefetch_loadsSameURLAfterComplete() {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		prefetch([url], sut: sut, loader: loader)
		XCTAssertEqual(loader.loadedURLs, [url], "Should load the URL on prefetch")

		loader.completeWith(.success(anyData()))

		prefetch([url], sut: sut, loader: loader)
		XCTAssertEqual(loader.loadedURLs, [url, url], "Should start a new load after completion")
	}

	func test_cancelPrefetching_cancelsTaskForGivenURLs() {
		let url1 = URL(string: "https://a.com")!
		let url2 = URL(string: "https://b.com")!
		let (sut, loader) = makeSUT()

		prefetch([url1, url2], sut: sut, loader: loader)
		cancelPrefetching([url1], sut: sut, loader: loader)

		XCTAssertEqual(loader.cancelledURLs, [url1])
	}

	// MARK: -

	func test_stressTest_prefetchAndCancelFromMultipleThreads() {
		let urls = (0..<100).map { URL(string: "https://test\($0).com")! }
		let (sut, _) = makeSUT()

		DispatchQueue.concurrentPerform(iterations: urls.count) { i in
			sut.prefetch(urls: [urls[i]])
			if i % 2 == 0 { sut.cancelPrefetching(urls: [urls[i]]) }
		}

		// No asserts — the test passes if it doesn’t crash
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: ImageDataPrefetcher,
		loader: ImageDataLoaderSpy
	) {
		let loader = ImageDataLoaderSpy()
		let sut = ImageDataPrefetcher(loader: loader)
		return (sut, loader)
	}

	private func prefetch(
		_ urls: [URL],
		sut: ImageDataPrefetcher,
		loader: ImageDataLoaderSpy
	) {
		let exp = expectation(description: "Wait for star load")
		exp.expectedFulfillmentCount = Set(urls).count

		loader.onLoad = {
			exp.fulfill()
		}

		sut.prefetch(urls: urls)

		wait(for: [exp], timeout: 0.1)
	}

	private func cancelPrefetching(
		_ urls: [URL],
		sut: ImageDataPrefetcher,
		loader: ImageDataLoaderSpy
	) {
		let exp = expectation(description: "Wait for cancel")
		exp.expectedFulfillmentCount = Set(urls).count

		loader.onCancel = {
			exp.fulfill()
		}

		sut.cancelPrefetching(urls: urls)

		wait(for: [exp], timeout: 0.1)
	}
}
