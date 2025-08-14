//
//  DeduplicatingImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 8/8/25.
//

import Foundation

public final class DeduplicatingImageDataLoader: ImageDataLoader {
	private let loader: ImageDataLoader

	private let queue = DispatchQueue(label: "\(DeduplicatingImageDataLoader.self)Queue")
	private var ongoingTasks = [URL: TaskEntry]()

	private struct TaskEntry {
		var task: ImageDataLoaderTask?
		var completions: [UUID: LoadCompletion]
	}

	private struct CallbackTask: ImageDataLoaderTask {
		let onCancel: () -> Void

		func cancel() { onCancel() }
	}

	public init(loader: ImageDataLoader) {
		self.loader = loader
	}

	@discardableResult
	public func load(url: URL, completion: @escaping LoadCompletion) -> ImageDataLoaderTask {
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
