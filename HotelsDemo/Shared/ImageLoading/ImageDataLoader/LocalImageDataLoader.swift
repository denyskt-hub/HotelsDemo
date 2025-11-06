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

	public init(cache: ImageDataCache) {
		self.cache = cache
	}

	public enum Error: Swift.Error {
		case notFound
	}

	@discardableResult
	public func load(url: URL, completion: @Sendable @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		cache.data(forKey: url.absoluteString) { result in
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

			completion(loadResult)
		}

		return EmptyImageDataLoaderTask()
	}
}
