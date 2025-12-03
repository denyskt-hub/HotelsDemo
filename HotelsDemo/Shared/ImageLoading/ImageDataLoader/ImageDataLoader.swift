//
//  ImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import Foundation

public protocol ImageDataLoader: Sendable {
	typealias LoadResult = Result<Data, Error>

	@discardableResult
	func load(url: URL) async throws -> Data
}

extension ImageDataLoader {
	func logging(_ tag: ImageDataLoaderLogTag) -> LoggingImageDataLoader {
		LoggingImageDataLoader(
			loader: self,
			logger: ImageDataLoadingLoggers.makeLogger(tag)
		)
	}
}
