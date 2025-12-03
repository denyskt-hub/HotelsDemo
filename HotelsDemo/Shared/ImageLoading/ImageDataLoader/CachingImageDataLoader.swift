//
//  CachingImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public final class CachingImageDataLoader: ImageDataLoader {
	private let loader: ImageDataLoader
	private let cache: ImageDataCache

	public init(
		loader: ImageDataLoader,
		cache: ImageDataCache
	) {
		self.loader = loader
		self.cache = cache
	}

	@discardableResult
	public func load(url: URL) async throws -> Data {
		let data = try await loader.load(url: url)
		try? await cache.save(data, forKey: url.absoluteString)
		return data
	}
}
