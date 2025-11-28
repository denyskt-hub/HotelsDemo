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

	public func load(url: URL) async throws -> Data {
		let task = Mutex<ImageDataLoaderTask?>(nil)
		return try await withTaskCancellationHandler(
			operation: {
				try await withCheckedThrowingContinuation { continuation in
					task.withLock {
						$0 = self.load(url: url) { result in
							switch result {
							case .success(let data):
								continuation.resume(returning: data)
							case .failure(let error):
								continuation.resume(throwing: error)
							}
						}
					}
				}
			},
			onCancel: {
				task.withLock({ $0 })?.cancel()
			})
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
