//
//  ImageDataPrefetcherTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 11/8/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class DefaultImageDataPrefetcherTests: XCTestCase {
	func test_prefetch_startsLoadingForEachURL() {
		let url1 = URL(string: "https://a.com")!
		let url2 = URL(string: "https://b.com")!
		let (sut, loader, delegate) = makeSUT()
		loader.stubWithData(anyData())

		prefetch([url1, url2], sut: sut, delegate: delegate)

		XCTAssertTrue(loader.loadedURLs.contains(url1))
		XCTAssertTrue(loader.loadedURLs.contains(url2))
	}

	func test_prefetch_doesNotStartDuplicateLoadsForSameURL() {
		let url = anyURL()
		let (sut, loader, delegate) = makeSUT()
		loader.stubWithData(anyData())

		prefetch([url, url], sut: sut, delegate: delegate)

		XCTAssertEqual(loader.loadedURLs, [url], "Should load only once")
	}

	func test_prefetch_loadsSameURLAfterComplete() {
		let url = anyURL()
		let (sut, loader, delegate) = makeSUT()
		loader.stubWithData(anyData())

		prefetch([url], sut: sut, delegate: delegate)
		XCTAssertEqual(loader.loadedURLs, [url], "Should load the URL on prefetch")

		prefetch([url], sut: sut, delegate: delegate)
		XCTAssertEqual(loader.loadedURLs, [url, url], "Should start a new load after completion")
	}

	func test_cancelPrefetching_cancelsTaskForGivenURLs() {
		let url1 = URL(string: "https://a.com")!
		let url2 = URL(string: "https://b.com")!
		let (sut, loader, delegate) = makeSUT()

		willPrefetch([url1, url2], sut: sut, delegate: delegate)
		cancelPrefetching([url1], sut: sut, loader: loader)

		XCTAssertEqual(loader.cancelledURLs, [url1])
	}

	// MARK: -

	func test_stressTest_prefetchAndCancelFromMultipleThreads() {
		let urls = (0..<100).map { URL(string: "https://test\($0).com")! }
		let (sut, _, _) = makeSUT()

		DispatchQueue.concurrentPerform(iterations: urls.count) { i in
			sut.prefetch(urls: [urls[i]])
			if i % 2 == 0 { sut.cancelPrefetching(urls: [urls[i]]) }
		}

		// No asserts — the test passes if it doesn’t crash
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DefaultImageDataPrefetcher,
		loader: ImageDataLoaderSpy,
		delegate: ImageDataPrefetcherDelegateSpy
	) {
		let loader = ImageDataLoaderSpy()
		let delegate = ImageDataPrefetcherDelegateSpy()
		let sut = DefaultImageDataPrefetcher(
			loader: loader,
			delegate: delegate
		)
		return (sut, loader, delegate)
	}

	private func willPrefetch(
		_ urls: [URL],
		sut: ImageDataPrefetcher,
		delegate: ImageDataPrefetcherDelegateSpy
	) {
		let exp = expectation(description: "Wait for will prefetch")
		let uniqueCount = Set(urls).count
		exp.expectedFulfillmentCount = uniqueCount

		delegate.onWillPrefetch = { _ in exp.fulfill() }

		sut.prefetch(urls: urls)

		wait(for: [exp], timeout: 0.1)
	}

	private func prefetch(
		_ urls: [URL],
		sut: ImageDataPrefetcher,
		delegate: ImageDataPrefetcherDelegateSpy
	) {
		let exp = expectation(description: "Wait for did prefetch")
		let uniqueCount = Set(urls).count
		exp.expectedFulfillmentCount = uniqueCount

		delegate.onDidPrefetch = { _ in exp.fulfill() }

		sut.prefetch(urls: urls)

		wait(for: [exp], timeout: 0.2)
	}

	private func cancelPrefetching(
		_ urls: [URL],
		sut: ImageDataPrefetcher,
		loader: ImageDataLoaderSpy
	) {
		let exp = expectation(description: "Wait for cancel")
		let uniqueCount = Set(urls).count
		exp.expectedFulfillmentCount = uniqueCount

		loader.onCancel = { exp.fulfill() }

		sut.cancelPrefetching(urls: urls)

		wait(for: [exp], timeout: 0.1)
	}
}

final class ImageDataPrefetcherDelegateSpy: ImageDataPrefetcherDelegate {
	private let _onWillPrefetch = Mutex<(@Sendable (URL) -> Void)?>(nil)
	var onWillPrefetch: (@Sendable (URL) -> Void)? {
		get { _onWillPrefetch.withLock { $0 } }
		set { _onWillPrefetch.withLock { $0 = newValue } }
	}

	private let _onDidPrefetch = Mutex<(@Sendable (URL) -> Void)?>(nil)
	var onDidPrefetch: (@Sendable (URL) -> Void)? {
		get { _onDidPrefetch.withLock { $0 } }
		set { _onDidPrefetch.withLock { $0 = newValue } }
	}

	func imageDataPrefetcher(_ prefetcher: ImageDataPrefetcher, willPrefetchDataForURL url: URL) {
		onWillPrefetch?(url)
	}

	func imageDataPrefetcher(_ prefetcher: ImageDataPrefetcher, didPrefetchDataForURL url: URL) {
		onDidPrefetch?(url)
	}
}
