//
//  PrefetchingImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/8/25.
//

import Foundation

public final class PrefetchingImageDataLoader: ImageDataLoader {
	private let loader: ImageDataLoader
	private let cache: ImageDataCache
	private let dispatcher: Dispatcher

	public init(
		loader: ImageDataLoader,
		cache: ImageDataCache,
		dispatcher: Dispatcher
	) {
		self.loader = loader
		self.cache = cache
		self.dispatcher = dispatcher
	}

	private final class PrefetchingImageDataLoaderTaskWrapper: ImageDataLoaderTask {
		var wrapped: ImageDataLoaderTask?

		public func cancel() {
			wrapped?.cancel()
		}
	}

	@discardableResult
	public func load(url: URL, completion: @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		let task = PrefetchingImageDataLoaderTaskWrapper()

		cache.data(forKey: url.absoluteString) { [weak self] result in
			guard let self else { return }

			if case let .success(data) = result, let data = data {
				self.dispatcher.dispatch {
					completion(.success(data))
				}
			} else {
				task.wrapped = self.loader.load(url: url, completion: completion)
			}
		}

		return task
	}
}
