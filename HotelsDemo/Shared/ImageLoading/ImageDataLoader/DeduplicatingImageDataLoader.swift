//
//  DeduplicatingImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 8/8/25.
//

import Foundation

public final class DeduplicatingImageDataLoader: ImageDataLoader {
	private let loader: ImageDataLoader
	private let deduplicatingLoader = DeduplicatingLoader<Data>()

	public init(loader: ImageDataLoader) {
		self.loader = loader
	}

	@discardableResult
	public func load(url: URL) async throws -> Data {
		try await deduplicatingLoader.load(from: url, loader: loader.load(url:))
	}
}
