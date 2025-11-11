//
//  DeduplicatingImageDataLoaderTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 11/8/25.
//

import XCTest
import HotelsDemo

final class DeduplicatingImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_init_doesNotMessageLoader() {
		let (_, loader) = makeSUT()

		XCTAssertTrue(loader.receivedMessages().isEmpty)
	}

	func test_load_deliversErrorOnLoaderError() {
		let loaderError = anyNSError()
		let (sut, loader) = makeSUT()

		expect(sut, toLoad: .failure(loaderError), when: {
			loader.completeWith(.failure(loaderError))
		})
	}

	func test_load_deliversDataOnLoaderSuccess() {
		let data = Data()
		let (sut, loader) = makeSUT()
		
		expect(sut, toLoad: .success(data), when: {
			loader.completeWith(.success(data))
		})
	}

	func test_load_deduplicatesRequestsForSameURL() {
		let url = anyURL()
		let (sut, loader) = makeSUT()
		
		sut.load(url: url) { _ in }
		sut.load(url: url) { _ in }

		XCTAssertEqual(loader.loadedURLs, [url], "Expected only one underlying load for same URL")
	}

	func test_load_requestsDifferentURLsIndependently() {
		let url1 = URL(string: "https://example.com/1")!
		let url2 = URL(string: "https://example.com/2")!
		let (sut, loader) = makeSUT()

		_ = sut.load(url: url1) { _ in }
		_ = sut.load(url: url2) { _ in }

		XCTAssertEqual(loader.loadedURLs, [url1, url2], "Expected separate loads for different URLs")
	}

	func test_load_deliversSameResultToAllConsumersForSameURL() throws {
		let (sut, loader) = makeSUT()

		let data = anyData()
		expect(sut, toLoadTwice: .success(data), when: {
			loader.completeWith(.success(data))
		})

		let error = anyNSError()
		expect(sut, toLoadTwice: .failure(error), when: {
			loader.completeWith(.failure(error))
		})
	}

	// MARK: -

	func test_cancel_doesNotCancelTaskWhileHasConsumers() {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		sut.load(url: url) { _ in }
		let task = sut.load(url: url) { _ in }
		task.cancel()

		XCTAssertEqual(loader.tasks.first?.cancelCallCount, 0)
	}

	func test_cancel_cancelsTaskWhenHasNoConsumers() {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		let task1 = sut.load(url: url) { _ in }
		let task2 = sut.load(url: url) { _ in }
		task1.cancel()
		task2.cancel()

		XCTAssertEqual(loader.tasks.first?.cancelCallCount, 1)
	}

	// MARK: -

	func test_load_isThreadSafeAndDeduplicates() {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		let exp = expectation(description: "Wait for completions")
		exp.expectedFulfillmentCount = 10

		DispatchQueue.concurrentPerform(iterations: 10) { _ in
			sut.load(url: url) { _ in exp.fulfill() }
		}

		loader.completeWith(.success(anyData()))

		wait(for: [exp], timeout: 1.0)

		XCTAssertEqual(loader.loadedURLs, [url])
	}

	func test_stressTest_loadAndCancelFromMultipleThreads() {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		let iterations = 100
		let exp = expectation(description: "Wait for completions")
		exp.expectedFulfillmentCount = iterations / 2

		DispatchQueue.concurrentPerform(iterations: iterations) { i in
			let task = sut.load(url: url) { _ in exp.fulfill() }
			if i % 2 == 0 { task.cancel() }
		}

		loader.completeWith(.success(anyData()))

		wait(for: [exp], timeout: 2.0)

		// No asserts — the test passes if it doesn’t crash
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DeduplicatingImageDataLoader,
		loader: ImageDataLoaderSpy
	) {
		let loader = ImageDataLoaderSpy()
		let sut = DeduplicatingImageDataLoader(loader: loader)
		return (sut, loader)
	}
}
