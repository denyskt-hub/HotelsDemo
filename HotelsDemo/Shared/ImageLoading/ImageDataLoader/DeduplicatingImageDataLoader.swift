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
	private let deduplicatingLoader = DeduplicatingLoader<Data>()

	public init(loader: ImageDataLoader) {
		self.loader = loader
	}

	@discardableResult
	public func load(url: URL) async throws -> Data {
		try await deduplicatingLoader.load(from: url, loader: loader.load(url:))
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
		guard let entry = ongoingTasks[url] else { return }

		entry.decrementConsumerCount()
		if entry.consumerCount == 0 {
			ongoingTasks[url] = nil
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
