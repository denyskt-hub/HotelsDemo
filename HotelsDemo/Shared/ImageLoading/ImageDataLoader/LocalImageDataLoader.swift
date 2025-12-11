//
//  LocalImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public final class LocalImageDataLoader: ImageDataLoader {
	private let cache: ImageDataCache

	public init(cache: ImageDataCache) {
		self.cache = cache
	}

	public enum Error: Swift.Error {
		case notFound
	}

	@discardableResult
	public func load(url: URL) async throws -> Data {
		let data = try await cache.data(forKey: url.absoluteString)
		guard let data else {
			throw Error.notFound
		}
		return data
	}
}
