//
//  DeduplicatingImageDataLoaderTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 11/8/25.
//

import XCTest
import HotelsDemo

@MainActor
final class DeduplicatingImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_init_doesNotMessageLoader() {
		let (_, loader) = makeSUT()

		XCTAssertTrue(loader.receivedMessages().isEmpty)
	}

	func test_load_deliversErrorOnLoaderError() async {
		let loaderError = anyNSError()
		let (sut, loader) = makeSUT()

		await expect(sut, toLoadWithError: loaderError, when: {
			loader.stubWithError(loaderError)
		})
	}

	func test_load_deliversDataOnLoaderSuccess() async {
		let data = Data()
		let (sut, loader) = makeSUT()
		
		await expect(sut, toLoadData: data, when: {
			loader.stubWithData(data)
		})
	}

	func test_load_deduplicatesRequestsForSameURL() async throws {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		async let first = sut.load(url: url)
		async let second = sut.load(url: url)
		// Two independent guarantees: the underlying load is suspended,
		// AND both consumers joined the shared entry.
		await loader.waitUntilStarted()
		await waitUntilActiveConsumers(of: sut, for: url, equal: 2)

		loader.completeWithData(anyData())
		_ = try await (first, second)

		XCTAssertEqual(loader.loadedURLs, [url], "Expected only one underlying load for same URL")
	}

	func test_load_requestsDifferentURLsIndependently() async throws {
		let url1 = URL(string: "https://example.com/1")!
		let url2 = URL(string: "https://example.com/2")!
		let (sut, loader) = makeSUT()

		loader.stubWithData(anyData())
		async let first = sut.load(url: url1)
		async let second = sut.load(url: url2)
		_ = try await (first, second)

		XCTAssertTrue(loader.loadedURLs.contains(url1))
		XCTAssertTrue(loader.loadedURLs.contains(url2))
	}

	func test_load_deliversSameResultToAllConsumersForSameURL() async {
		let (sut, loader) = makeSUT()

		let data = anyData()
		await expect(sut, toLoadTwice: .success(data), when: {
			loader.stubWithData(data)
		})

		let error = anyNSError()
		await expect(sut, toLoadTwice: .failure(error), when: {
			loader.stubWithError(error)
		})
	}

	// MARK: -

	func test_cancel_doesNotCancelTaskWhileHasConsumers() async throws {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		let firstTask = Task { try await sut.load(url: url) }
		let secondTask = Task { try await sut.load(url: url) }
		await loader.waitUntilStarted()
		await waitUntilActiveConsumers(of: sut, for: url, equal: 2)

		secondTask.cancel()
		await waitUntilActiveConsumers(of: sut, for: url, equal: 1)

		XCTAssertEqual(loader.tasks.first?.cancelCallCount, 0)

		loader.completeWithData(anyData())
		_ = await (firstTask.result, secondTask.result)
	}

	func test_cancel_deliversCancellationErrorToCancelledConsumer() async throws {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		let firstTask = Task { try await sut.load(url: url) }
		let secondTask = Task { try await sut.load(url: url) }
		await loader.waitUntilStarted()
		await waitUntilActiveConsumers(of: sut, for: url, equal: 2)

		secondTask.cancel()
		await waitUntilActiveConsumers(of: sut, for: url, equal: 1)
		loader.completeWithData(anyData())

		let firstResult = await firstTask.result
		let secondResult = await secondTask.result

		XCTAssertNotNil(try? firstResult.get(), "Active consumer should receive the data")
		XCTAssertThrowsError(try secondResult.get()) { error in
			XCTAssertTrue(error is CancellationError, "Cancelled consumer should report cancellation, got \(error)")
		}
	}

	func test_cancel_cancelsTaskWhenHasNoConsumers() async throws {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		let firstTask = Task { try await sut.load(url: url) }
		let secondTask = Task { try await sut.load(url: url) }
		await loader.waitUntilStarted()
		await waitUntilActiveConsumers(of: sut, for: url, equal: 2)

		firstTask.cancel()
		secondTask.cancel()
		await waitUntilActiveConsumers(of: sut, for: url, equal: 0)

		XCTAssertEqual(loader.tasks.first?.cancelCallCount, 1)

		_ = await (firstTask.result, secondTask.result)
	}

	// MARK: -

	func test_stress_asyncLoadAndCancel() async {
		let url = anyURL()
		let (sut, loader) = makeSUT()
		loader.stubWithData(anyData())

		await withTaskGroup(of: Void.self) { group in
			for i in 0..<100 {
				group.addTask {
					let t = Task { try? await sut.load(url: url) }
					if i % 2 == 0 { t.cancel() }
					_ = await t.result
				}
			}
		}

		// No assert — passes if it doesn’t crash or hang
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DeduplicatingImageDataLoader,
		loader: ImageDataLoaderSpy
	) {
		let loader = ImageDataLoaderSpy()
		let sut = DeduplicatingImageDataLoader(loader: loader)
		trackForMemoryLeaks(loader)
		trackForMemoryLeaks(sut)
		return (sut, loader)
	}

	/// Suspends until the deduplicated load for `url` has exactly `count`
	/// active consumers — deterministic synchronization with no wall-clock.
	private func waitUntilActiveConsumers(
		of sut: DeduplicatingImageDataLoader,
		for url: URL,
		equal count: Int
	) async {
		while await sut.activeConsumers(for: url) != count {
			await Task.yield()
		}
	}
}
