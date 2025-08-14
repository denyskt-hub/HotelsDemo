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

	public init(
		loader: ImageDataLoader,
		cache: ImageDataCache
	) {
		self.loader = loader
		self.cache = cache
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
				completion(.success(data))
			} else {
				task.wrapped = self.loader.load(url: url, completion: completion)
			}
		}

		return task
	}
}
