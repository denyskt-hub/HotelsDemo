//
//  LocalImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public struct EmptyImageDataLoaderTask: ImageDataLoaderTask {
	public func cancel() {}
}

public final class LocalImageDataLoader: ImageDataLoader {
	private let cache: ImageDataCache
	private let dispatcher: Dispatcher

	public init(
		cache: ImageDataCache,
		dispatcher: Dispatcher
	) {
		self.cache = cache
		self.dispatcher = dispatcher
	}

	public enum Error: Swift.Error {
		case notFound
	}

	public func load(url: URL, completion: @escaping LoadCompletion) -> ImageDataLoaderTask {
		cache.data(forKey: url.absoluteString) { [weak self] result in
			guard let self else { return }

			let loadResult = LoadResult {
				switch result {
				case let .success(data):
					guard let data = data else {
						throw Error.notFound
					}
					return data
				case let .failure(error):
					throw error
				}
			}

			self.dispatcher.dispatch {
				completion(loadResult)
			}
		}
		return EmptyImageDataLoaderTask()
	}
}
