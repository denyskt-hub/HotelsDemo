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

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	@available(*, deprecated, message: "Use async version")
	func save(_ data: Data, forKey key: String, completion: @Sendable @escaping (SaveResult) -> Void)

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	@available(*, deprecated, message: "Use async version")
	func data(forKey key: String, completion: @Sendable @escaping (DataResult) -> Void)

	func save(_ data: Data, forKey key: String) async throws
	func data(forKey key: String) async throws -> Data?
}

extension ImageDataCache {
	public func save(_ data: Data, forKey key: String) async throws {
		try await withCheckedThrowingContinuation { continuation in
			save(data, forKey: key) { result in
				switch result {
				case .success:
					continuation.resume(returning: ())
				case let .failure(error):
					continuation.resume(throwing: error)
				}
			}
		}
	}

	public func data(forKey key: String) async throws -> Data? {
		try await withCheckedThrowingContinuation { continuation in
			data(forKey: key) { result in
				switch result {
				case let .success(data):
					continuation.resume(returning: data)
				case let .failure(error):
					continuation.resume(throwing: error)
				}
			}
		}
	}
}

extension ImageDataCache {
	func logging(_ tag: ImageDataCacheLogTag) -> LoggingImageDataCache {
		LoggingImageDataCache(
			cache: self,
			logger: ImageDataCacheLoggers.makeLogger(tag)
		)
	}
}
