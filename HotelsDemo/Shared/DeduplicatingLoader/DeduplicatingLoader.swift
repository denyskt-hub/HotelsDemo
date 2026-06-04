//
//  DeduplicatingLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11.12.2025.
//

import Foundation

public actor DeduplicatingLoader<Output: Sendable> {
	private var ongoingTasks = [URL: TaskEntry]()
	private var generation = 0

	public init() {}

	public func load(
		from url: URL,
		loader: @Sendable @escaping (URL) async throws -> Output
	) async throws -> Output {
		let (task, generation) = join(url: url, loader: loader)

		let result: Result<Output, Error>
		do {
			let value = try await withTaskCancellationHandler {
				try await task.value
			} onCancel: {
				Task { await self.cancelConsumer(of: url, generation: generation) }
			}
			result = .success(value)
		} catch {
			result = .failure(error)
		}

		finish(url: url, generation: generation)

		// A cancelled consumer must report cancellation,
		// not the shared task's result.
		try Task.checkCancellation()
		return try result.get()
	}

	/// The number of consumers currently awaiting the load for `url`
	/// that have not been cancelled. Intended for tests to synchronize
	/// on deduplication deterministically.
	func activeConsumers(for url: URL) -> Int {
		ongoingTasks[url]?.activeConsumers ?? 0
	}

	/// Joins an ongoing load for `url`, or starts a new one.
	private func join(
		url: URL,
		loader: @Sendable @escaping (URL) async throws -> Output
	) -> (Task<Output, Error>, Int) {
		if let entry = ongoingTasks[url] {
			ongoingTasks[url]?.activeConsumers += 1
			return (entry.task, entry.generation)
		}

		generation += 1
		let task = Task { try await loader(url) }
		ongoingTasks[url] = TaskEntry(
			task: task,
			generation: generation,
			activeConsumers: 1
		)
		return (task, generation)
	}

	/// Cancellation is addressed to the entry the consumer joined —
	/// a stale cancel must never affect a newer load for the same URL.
	private func cancelConsumer(of url: URL, generation: Int) {
		guard let entry = ongoingTasks[url], entry.generation == generation else { return }

		ongoingTasks[url]?.activeConsumers -= 1
		if ongoingTasks[url]?.activeConsumers == 0 {
			entry.task.cancel()
			ongoingTasks[url] = nil
		}
	}

	private func finish(url: URL, generation: Int) {
		guard ongoingTasks[url]?.generation == generation else { return }
		ongoingTasks[url] = nil
	}

	private struct TaskEntry {
		let task: Task<Output, Error>
		let generation: Int
		var activeConsumers: Int
	}
}
