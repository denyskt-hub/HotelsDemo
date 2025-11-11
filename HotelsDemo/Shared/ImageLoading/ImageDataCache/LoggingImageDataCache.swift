//
//  LoggingImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation

public final class LoggingImageDataCache: ImageDataCache {
	private let cache: ImageDataCache
	private let logger: ImageDataCacheLogger

	public init(
		cache: ImageDataCache,
		logger: ImageDataCacheLogger
	) {
		self.cache = cache
		self.logger = logger
	}

	public func save(_ data: Data, forKey key: String, completion: @Sendable @escaping (SaveResult) -> Void) {
		#if DEBUG
		cache.save(data, forKey: key) { result in
			self.logger.log(saveResult: result, forKey: key)
			completion(result)
		}
		#else
		cache.save(data, forKey: key, completion: completion)
		#endif
	}

	public func data(forKey key: String, completion: @Sendable @escaping (DataResult) -> Void) {
		#if DEBUG
		cache.data(forKey: key) { result in
			self.logger.log(dataResult: result, forKey: key)
			completion(result)
		}
		#else
		cache.data(forKey: key, completion: completion)
		#endif
	}
}
