//
//  LoggingImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation

public final class LoggingImageDataCache: ImageDataCache {
	private let cache: ImageDataCache

	public init(cache: ImageDataCache) {
		self.cache = cache
	}

	public func save(_ data: Data, forKey key: String, completion: @escaping ((Error)?) -> Void) {
		cache.save(data, forKey: key) { error in
			if error == nil {
				Logger.log("Save success for key: \(key)", tag: .custom("cache"))
			} else {
				Logger.log("Save failure for key: \(key)", tag: .custom("cache"))
			}

			completion(error)
		}
	}

	public func data(forKey key: String, completion: @escaping (Result<Data?, Error>) -> Void) {
		cache.data(forKey: key) { result in
			if case let .success(data) = result, data != nil {
				Logger.log("Load success for key: \(key)", tag: .custom("cache"))
			} else {
				Logger.log("Load failure for key: \(key)", tag: .custom("cache"))
			}

			completion(result)
		}
	}
}
