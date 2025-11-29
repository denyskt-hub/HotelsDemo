//
//  ImageDataLoaderSpy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 29/11/25.
//

import Foundation
import HotelsDemo
import Synchronization

final class ImageDataLoaderSpy: ImageDataLoader {
	typealias Message = (url: URL, task: TaskSpy)

	private let messages = Mutex<[Message]>([])
	private let completions = Mutex<[(LoadResult) -> Void]>([])
	private let continuations = Mutex<[CheckedContinuation<Data, Error>]>([])

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

		messages.withLock { $0.append((url, task)) }
		completions.withLock { $0.append(completion) }

		onLoad?()
		return task
	}

	private let stream = AsyncStream<Void>.makeStream()

	private let loadStub = Mutex<LoadResult?>(nil)

	func load(url: URL) async throws -> Data {
		let task = TaskSpy()
		task.onCancel = { [weak self] in self?.cancel() }
		
		messages.withLock { $0.append((url, task)) }

		return try await withTaskCancellationHandler {
			try await withCheckedThrowingContinuation { continuation in
				guard !Task.isCancelled else {
					continuation.resume(throwing: CancellationError())
					return
				}
				
				if let loadStub = loadStub.withLock({ $0 }) {
					switch loadStub {
					case let .success(data):
						continuation.resume(returning: data)
					case let .failure(error):
						continuation.resume(throwing: error)
					}
				} else {
					continuations.withLock { $0.append(continuation) }
					stream.continuation.yield(())
				}
			}
		} onCancel: {
			task.cancel()
		}
	}

	func task(for url: URL) -> TaskSpy? {
		messages.withLock({ $0 }).first(where: { $0.url == url })?.task
	}

	func completeWith(_ result: LoadResult, at index: Int = 0) {
		completions.withLock({ $0 })[index](result)
	}

	func completeWithData(_ data: Data, at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(returning: data)
	}

	func completeWithError(_ error: Error, at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(throwing: error)
	}

	func stubWithData(_ data: Data) {
		loadStub.withLock { $0 = .success(data) }
	}

	func stubWithError(_ error: Error) {
		loadStub.withLock { $0 = .failure(error) }
	}

	func waitUntilStarted() async {
		var iterator = stream.stream.makeAsyncIterator()
		_ = await iterator.next()
	}

	private func cancel() {
		onCancel?()
	}
}
