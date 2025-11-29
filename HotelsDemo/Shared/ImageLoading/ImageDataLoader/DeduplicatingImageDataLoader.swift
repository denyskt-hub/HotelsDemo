//
//  DeduplicatingImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 8/8/25.
//

import Foundation
import Synchronization

public final class DeduplicatingImageDataLoader: ImageDataLoader, @unchecked Sendable {
	private let loader: ImageDataLoader

	private let queue = DispatchQueue(label: "\(DeduplicatingImageDataLoader.self)Queue")
	private var ongoingTasks = [URL: TaskEntry]()

	private struct TaskEntry {
		var task: ImageDataLoaderTask?
		var completions: [UUID: (LoadResult) -> Void]
	}

	private struct CallbackTask: ImageDataLoaderTask {
		let onCancel: @Sendable () -> Void

		func cancel() { onCancel() }
	}

	public init(loader: ImageDataLoader) {
		self.loader = loader
	}

	@discardableResult
	public func load(url: URL, completion: @Sendable @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		let id = UUID()
		var shouldStart = false

		queue.sync {
			if var entry = ongoingTasks[url] {
				entry.completions[id] = completion
				ongoingTasks[url] = entry
			} else {
				ongoingTasks[url] = TaskEntry(task: nil, completions: [id: completion])
				shouldStart = true
			}
		}

		if shouldStart {
			let task = loader.load(url: url) { [weak self] result in
				self?.complete(url: url, with: result)
			}

			queue.sync {
				if var entry = ongoingTasks[url] {
					entry.task = task
					ongoingTasks[url] = entry
				}
			}
		}

		return CallbackTask { [weak self] in
			self?.cancel(id: id, url: url)
		}
	}

	private let deduplicatingLoader = DeduplicatingLoader<Data>()

	@discardableResult
	public func load(url: URL) async throws -> Data {
		try await deduplicatingLoader.load(from: url, loader: loader.load(url:))
	}

	private func complete(url: URL, with result: ImageDataLoader.LoadResult) {
		let completions = queue.sync {
			ongoingTasks.removeValue(forKey: url)?.completions.values
		}

		completions?.forEach { completion in
			completion(result)
		}
	}

	private func cancel(id: UUID, url: URL) {
		queue.sync {
			guard var entry = ongoingTasks[url] else { return }

			entry.completions.removeValue(forKey: id)

			if entry.completions.isEmpty {
				entry.task?.cancel()
				ongoingTasks[url] = nil
			} else {
				ongoingTasks[url] = entry
			}
		}
	}
}

actor DeduplicatingLoader<Output: Sendable> {
	private var ongoingTasks = [URL: TaskEntry<Output>]()

	func load(from url: URL, loader: @Sendable @escaping (URL) async throws -> Output) async throws -> Output {
		try await withTaskCancellationHandler {
			if let entry = ongoingTasks[url] {
				entry.incrementConsumerCount()
				return try await entry.task.value
			}

			let newTask = Task { try await loader(url) }
			let entry = TaskEntry(task: newTask)
			ongoingTasks[url] = entry

			do {
				let result = try await newTask.value
				ongoingTasks[url] = nil
				return result
			} catch {
				ongoingTasks[url] = nil
				throw error
			}
		} onCancel: {
			Task { await cancel(url) }
		}
	}

	private func cancel(_ url: URL) {
		if let entry = ongoingTasks[url] {
			entry.decrementConsumerCount()
			if entry.consumerCount == 0 {
				ongoingTasks[url] = nil
			}
		}
	}

	private final class TaskEntry<T: Sendable> {
		let task: Task<T, Error>
		var consumerCount = 1

		init(task: Task<T, Error>) {
			self.task = task
		}

		func incrementConsumerCount() {
			consumerCount += 1
		}

		func decrementConsumerCount() {
			consumerCount -= 1
			if consumerCount == 0 {
				task.cancel()
			}
		}
	}
}
