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

	public func save(_ data: Data, forKey key: String) async throws {
		#if DEBUG
		do {
			try await cache.save(data, forKey: key)
			logger.log(saveResult: .success(()), forKey: key)
		} catch {
			logger.log(saveResult: .failure(error), forKey: key)
			throw error
		}
		#else
		try await cache.save(data, forKey: key)
		#endif
	}

	public func data(forKey key: String) async throws -> Data? {
		#if DEBUG
		do {
			let data = try await cache.data(forKey: key)
			logger.log(dataResult: .success(data), forKey: key)
			return data
		} catch {
			logger.log(dataResult: .failure(error), forKey: key)
			throw error
		}
		#else
		try await cache.data(forKey: key)
		#endif
	}
}
