//
//  ImagePrefetcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/8/25.
//

import Foundation

public final class DefaultImageDataPrefetcher: ImageDataPrefetcher {
	private let loader: ImageDataLoader
	private let delegate: ImageDataPrefetcherDelegate?
	private let tasks = PrefetcherTaskStore()

	public init(
		loader: ImageDataLoader,
		delegate: ImageDataPrefetcherDelegate? = nil
	) {
		self.loader = loader
		self.delegate = delegate
	}

	public func prefetch(urls: [URL]) {
		Task {
			for url in urls {
				await tasks.addTaskIfNeeded(for: url) {
					Task { [weak self] in
						guard let self else { return }
						self.delegate?.imageDataPrefetcher(self, willPrefetchDataForURL: url)

						_ = try? await self.loader.load(url: url)
						await self.tasks.removeTask(for: url)

						self.delegate?.imageDataPrefetcher(self, didPrefetchDataForURL: url)
					}
				}
			}
		}
	}

	public func cancelPrefetching(urls: [URL]) {
		Task {
			for url in urls {
				await tasks.cancelTask(for: url)
			}
		}
	}

	private actor PrefetcherTaskStore {
		public typealias PrefetcherTask = Task<Void, Never>

		private var tasks = [URL: PrefetcherTask]()

		public init() {}

		public func getTask(for url: URL) -> PrefetcherTask? {
			tasks[url]
		}

		public func addTaskIfNeeded(for url: URL, makeTask: @Sendable () -> PrefetcherTask) {
			guard tasks[url] == nil else { return }
			tasks[url] = makeTask()
		}

		@discardableResult
		public func removeTask(for url: URL) -> PrefetcherTask? {
			tasks.removeValue(forKey: url)
		}

		public func cancelTask(for url: URL) {
			guard let task = removeTask(for: url) else { return }
			task.cancel()
		}
	}
}
