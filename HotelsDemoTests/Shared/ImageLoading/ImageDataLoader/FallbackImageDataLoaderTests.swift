//
//  FallbackImageDataLoaderTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

final class FallbackImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_load_deliversPrimaryResultOnSuccess() {
		let primaryData = anyData()
		let (sut, primary, _) = makeSUT()

		expect(sut, toLoad: .success(primaryData), when: {
			primary.completeWith(.success(primaryData))
		})
	}

	func test_load_deliversSecondaryResultOnPrimaryFailure() {
		let (primaryError, secondaryData) = (anyNSError(), anyData())
		let (sut, primary, secondary) = makeSUT()

		expect(sut, toLoad: .success(secondaryData), when: {
			primary.completeWith(.failure(primaryError))
			secondary.completeWith(.success(secondaryData))
		})
	}

	func test_load_deliversErrorWhenBothPrimaryAndSecondaryFail() {
		let (primaryError, secondaryError) = (anyNSError(), anyNSError())
		let (sut, primary, secondary) = makeSUT()

		expect(sut, toLoad: .failure(secondaryError), when: {
			primary.completeWith(.failure(primaryError))
			secondary.completeWith(.failure(secondaryError))
		})
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: FallbackImageDataLoader,
		primary: ImageDataLoaderSpy,
		secondary: ImageDataLoaderSpy
	) {
		let primary = ImageDataLoaderSpy()
		let secondary = ImageDataLoaderSpy()
		let sut = FallbackImageDataLoader(primary: primary, secondary: secondary)
		return (sut, primary, secondary)
	}
}

final class ImageDataLoaderSpy: ImageDataLoader {
	private(set) var messages = [(url: URL, task: TaskSpy, completion: LoadCompletion)]()

	var loadedURLs: [URL] { messages.map { $0.url } }

	var cancelledURLs: [URL] {
		messages
			.filter { $0.task.cancelCallCount > 0 }
			.map { $0.url }
	}

	var tasks: [TaskSpy] { messages.map { $0.task } }

	var onLoad: (() -> Void)?
	var onCancel: (() -> Void)?

	final class TaskSpy: ImageDataLoaderTask {
		private(set) var cancelCallCount = 0

		var onCancel: (() -> Void)?

		func cancel() {
			cancelCallCount += 1
			onCancel?()
		}
	}

	func load(url: URL, completion: @escaping LoadCompletion) -> ImageDataLoaderTask {
		let task = TaskSpy()
		task.onCancel = { [weak self] in self?.cancel() }

		messages.append((url, task, completion))
		
		onLoad?()
		return task
	}

	func task(for url: URL) -> TaskSpy? {
		messages.first(where: { $0.url == url })?.task
	}

	func completeWith(_ result: LoadResult, at index: Int = 0) {
		messages[index].completion(result)
	}

	private func cancel() {
		onCancel?()
	}
}
