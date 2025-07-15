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

	public func load(url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
		cache.data(forKey: url.absoluteString) { result in
			switch result {
			case let .success(data):
				if let data = data {
					completion(.success(data))
				}
				else {
					completion(.failure(Error.notFound))
				}
			case let .failure(error):
				completion(.failure(error))
			}
		}
		return EmptyImageDataLoaderTask()
	}
}
