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
	private let pendingLoads = Mutex<[PendingLoad]>([])

	/// Per-load state machine guaranteeing the continuation is resumed exactly
	/// once, no matter in which phase cancellation arrives (before suspension,
	/// while suspended, or racing a completion).
	private final class PendingLoad: Sendable {
		private enum State {
			case idle
			case suspended(CheckedContinuation<Data, Error>)
			case finished
		}

		private let state = Mutex<State>(.idle)

		var isFinished: Bool {
			state.withLock {
				if case .finished = $0 { return true }
				return false
			}
		}

		/// Stores the continuation; returns `false` if the load already
		/// finished (e.g. was cancelled before it could suspend).
		func suspend(_ continuation: CheckedContinuation<Data, Error>) -> Bool {
			state.withLock {
				guard case .idle = $0 else { return false }
				$0 = .suspended(continuation)
				return true
			}
		}

		/// Atomically extracts the continuation at most once.
		func take() -> CheckedContinuation<Data, Error>? {
			state.withLock { state in
				defer { state = .finished }
				if case let .suspended(continuation) = state { return continuation }
				return nil
			}
		}
	}

	var loadedURLs: [URL] { receivedMessages().map { $0.url } }

	var cancelledURLs: [URL] {
		receivedMessages()
			.filter { $0.task.cancelCallCount > 0 }
			.map { $0.url }
	}

	var tasks: [TaskSpy] { receivedMessages().map { $0.task } }

	private let _onCancel = Mutex<(@Sendable () -> Void)?>(nil)
	var onCancel: (@Sendable () -> Void)? {
		get { _onCancel.withLock { $0 } }
		set { _onCancel.withLock { $0 = newValue } }
	}

	final class TaskSpy: Sendable {
		private let _cancelCallCount = Mutex<Int>(0)
		var cancelCallCount: Int {
			get { _cancelCallCount.withLock({ $0 }) }
			set { _cancelCallCount.withLock({ $0 = newValue }) }
		}

		private let _onCancel = Mutex<(@Sendable () -> Void)?>(nil)
		var onCancel: (@Sendable () -> Void)? {
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

	private let stream = AsyncStream<Void>.makeStream()

	private let loadStub = Mutex<Result<Data, Error>?>(nil)

	func load(url: URL) async throws -> Data {
		let task = TaskSpy()
		task.onCancel = { [weak self] in self?.cancel() }

		let pending = PendingLoad()

		messages.withLock { $0.append((url, task)) }

		return try await withTaskCancellationHandler {
			// Keeps loads in flight long enough for concurrent consumers to
			// join the same underlying load — the deduplication tests rely on
			// this overlap window. Removing it requires making
			// `DeduplicatingImageDataLoader` observable instead.
			try? await Task.sleep(nanoseconds: 100_000_000)

			return try await withCheckedThrowingContinuation { continuation in
				guard !pending.isFinished else {
					// Cancelled while sleeping.
					continuation.resume(throwing: CancellationError())
					return
				}

				if let loadStub = loadStub.withLock({ $0 }) {
					continuation.resume(with: loadStub)
					return
				}

				guard pending.suspend(continuation) else {
					// Cancelled between the check above and suspension.
					continuation.resume(throwing: CancellationError())
					return
				}

				pendingLoads.withLock { $0.append(pending) }
				stream.continuation.yield(())
			}
		} onCancel: {
			task.cancel()
			// Deterministic cancellation: wake the suspended load no matter
			// when the cancel arrives — a continuation must never stay parked.
			pending.take()?.resume(throwing: CancellationError())
		}
	}

	func task(for url: URL) -> TaskSpy? {
		messages.withLock({ $0 }).first(where: { $0.url == url })?.task
	}

	func completeWithData(_ data: Data, at index: Int = 0) {
		let pending = pendingLoads.withLock { $0[index] }
		pending.take()?.resume(returning: data)
		stream.continuation.yield(())
	}

	func completeWithError(_ error: Error, at index: Int = 0) {
		let pending = pendingLoads.withLock { $0[index] }
		pending.take()?.resume(throwing: error)
		stream.continuation.yield(())
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

	func waitUntilCompleted() async {
		var iterator = stream.stream.makeAsyncIterator()
		_ = await iterator.next()
	}

	private func cancel() {
		onCancel?()
	}
}
