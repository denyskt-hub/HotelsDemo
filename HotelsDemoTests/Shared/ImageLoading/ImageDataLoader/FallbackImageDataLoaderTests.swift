//
//  FallbackImageDataLoaderTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo
import Synchronization

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
	typealias Message = (url: URL, task: TaskSpy, completion: (LoadResult) -> Void)

	private let messages = Mutex<[Message]>([])

	var loadedURLs: [URL] { receivedMessages().map { $0.url } }

	var cancelledURLs: [URL] {
		receivedMessages()
			.filter { $0.task.cancelCallCount > 0 }
			.map { $0.url }
	}

	var tasks: [TaskSpy] { receivedMessages().map { $0.task } }

	private let _onLoad = Mutex<(() -> Void)?>(nil)
	var onLoad: (() -> Void)? {
		get { _onLoad.withLock { $0 } }
		set { _onLoad.withLock { $0 = newValue } }
	}

	private let _onCancel = Mutex<(() -> Void)?>(nil)
	var onCancel: (() -> Void)? {
		get { _onCancel.withLock { $0 } }
		set { _onCancel.withLock { $0 = newValue } }
	}

	final class TaskSpy: ImageDataLoaderTask {
		private let _cancelCallCount = Mutex<Int>(0)
		var cancelCallCount: Int {
			get { _cancelCallCount.withLock({ $0 }) }
			set { _cancelCallCount.withLock({ $0 = newValue }) }
		}

		private let _onCancel = Mutex<(() -> Void)?>(nil)
		var onCancel: (() -> Void)? {
			get { _onCancel.withLock({ $0 }) }
			set { _onCancel.withLock({ $0 = newValue }) }
		}

		func cancel() {
			cancelCallCount += 1
			onCancel?()
		}
	}

	func receivedMessages() -> [Message] {
		messages.withLock { $0 }
	}

	func load(url: URL, completion: @Sendable @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		let task = TaskSpy()
		task.onCancel = { [weak self] in self?.cancel() }

		messages.withLock { $0.append((url, task, completion)) }

		onLoad?()
		return task
	}

	func task(for url: URL) -> TaskSpy? {
		messages.withLock({ $0 }).first(where: { $0.url == url })?.task
	}

	func completeWith(_ result: LoadResult, at index: Int = 0) {
		messages.withLock({ $0 })[index].completion(result)
	}

	private func cancel() {
		onCancel?()
	}
}
