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

	public func load(url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
		cache.data(forKey: url.absoluteString) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(data):
				if let data = data {
					self.dispatcher.dispatch {
						completion(.success(data))
					}
				}
				else {
					self.dispatcher.dispatch {
						completion(.failure(Error.notFound))
					}
				}
			case let .failure(error):
				self.dispatcher.dispatch {
					completion(.failure(error))
				}
			}
		}
		return EmptyImageDataLoaderTask()
	}
}
