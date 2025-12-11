//
//  ImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public protocol ImageDataCache: Sendable {
	typealias SaveResult = Result<Void, Error>
	typealias DataResult = Result<Data?, Error>

	func save(_ data: Data, forKey key: String) async throws
	func data(forKey key: String) async throws -> Data?
}

extension ImageDataCache {
	func logging(_ tag: ImageDataCacheLogTag) -> LoggingImageDataCache {
		LoggingImageDataCache(
			cache: self,
			logger: ImageDataCacheLoggers.makeLogger(tag)
		)
	}
}
