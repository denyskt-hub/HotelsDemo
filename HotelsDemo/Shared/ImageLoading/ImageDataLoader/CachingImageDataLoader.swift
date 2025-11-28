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
	public func load(url: URL, completion: @Sendable @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		loader.load(url: url) { [weak self] result in
			if case let .success(data) = result {
				self?.cache.saveIgnoringResult(data, forKey: url.absoluteString)
			}

			completion(result)
		}
	}

	public func load(url: URL) async throws -> Data {
		let data = try await loader.load(url: url)
		cache.saveIgnoringResult(data, forKey: url.absoluteString)
		return data
	}
}
