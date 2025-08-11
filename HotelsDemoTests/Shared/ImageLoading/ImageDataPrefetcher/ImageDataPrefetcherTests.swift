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

		sut.prefetch(urls: [url1, url2])

		XCTAssertEqual(loader.loadedURLs, [url1, url2])
	}

	func test_prefetch_doesNotStartDuplicateLoadsForSameURL() {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		sut.prefetch(urls: [url])
		sut.prefetch(urls: [url])

		XCTAssertEqual(loader.loadedURLs, [url], "Should load only once")
	}

	func test_prefetch_loadsSameURLAfterComplete() {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		sut.prefetch(urls: [url])
		XCTAssertEqual(loader.loadedURLs, [url], "Should load the URL on prefetch")

		loader.completeWith(.success(anyData()))

		sut.prefetch(urls: [url])
		XCTAssertEqual(loader.loadedURLs, [url, url], "Should start a new load after completion")
	}

	func test_cancelPrefetching_cancelsTaskForGivenURLs() {
		let url1 = URL(string: "https://a.com")!
		let url2 = URL(string: "https://b.com")!
		let (sut, loader) = makeSUT()

		sut.prefetch(urls: [url1, url2])
		sut.cancelPrefetching(urls: [url1])

		XCTAssertEqual(loader.cancelledURLs, [url1])
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
}
