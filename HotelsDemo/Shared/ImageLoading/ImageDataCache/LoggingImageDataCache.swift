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
