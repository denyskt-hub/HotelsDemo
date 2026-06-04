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

	func test_prefetch_doesNotStartDuplicateLoadsForSameURL() async {
		let url = anyURL()
		let otherURL = URL(string: "https://other.com")!
		let (sut, loader, delegate) = makeSUT()

		let started = expectation(description: "Wait for unique loads to start")
		started.expectedFulfillmentCount = 2
		delegate.onWillPrefetch = { _ in started.fulfill() }

		let drained = expectation(description: "Wait for all tasks to finish")
		drained.expectedFulfillmentCount = 2
		delegate.onDidPrefetch = { _ in drained.fulfill() }

		// No stub: loads stay suspended, so the first load for `url` is
		// guaranteed to still be in flight when its duplicate is processed.
		// `otherURL` comes last to prove the duplicate was already skipped
		// by the time we assert.
		sut.prefetch(urls: [url, url, otherURL])
		await fulfillment(of: [started], timeout: 1.0)

		// The two inner load tasks race each other, so assert order-agnostically.
		XCTAssertEqual(Set(loader.loadedURLs), [url, otherURL], "Should load each unique URL once")
		XCTAssertEqual(loader.loadedURLs.count, 2, "Should load each unique URL once")

		// Both loads must reach suspension before being completed.
		await loader.waitUntilStarted()
		await loader.waitUntilStarted()
		loader.completeWithData(anyData(), at: 0)
		loader.completeWithData(anyData(), at: 1)
		await fulfillment(of: [drained], timeout: 1.0)
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

		let drained = expectation(description: "Wait for all tasks to finish")
		drained.expectedFulfillmentCount = 2
		delegate.onDidPrefetch = { _ in drained.fulfill() }

		cancelPrefetching([url1], sut: sut, loader: loader)

		XCTAssertEqual(loader.cancelledURLs, [url1])

		// Drain: cancel the remaining task so nothing outlives the test.
		cancelPrefetching([url2], sut: sut, loader: loader)
		wait(for: [drained], timeout: 1.0)
	}

	// MARK: -

	func test_stressTest_prefetchAndCancelFromMultipleThreads() {
		let urls = (0..<100).map { URL(string: "https://test\($0).com")! }
		let (sut, loader, delegate) = makeSUT()
		loader.stubWithData(anyData())

		let drained = expectation(description: "Wait for all prefetches to finish")
		drained.expectedFulfillmentCount = urls.count
		delegate.onDidPrefetch = { _ in drained.fulfill() }

		DispatchQueue.concurrentPerform(iterations: urls.count) { i in
			sut.prefetch(urls: [urls[i]])
			if i % 2 == 0 { sut.cancelPrefetching(urls: [urls[i]]) }
		}

		// Every started task must complete (with data or cancellation) —
		// nothing may outlive the test.
		wait(for: [drained], timeout: 5.0)
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
		trackForMemoryLeaks(loader)
		trackForMemoryLeaks(delegate)
		trackForMemoryLeaks(sut)
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
