//
//  ImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import Foundation

public protocol ImageDataLoaderTask: Sendable {
	func cancel()
}

public protocol ImageDataLoader: Sendable {
	typealias LoadResult = Result<Data, Error>

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	@discardableResult
	func load(url: URL, completion: @Sendable @escaping (LoadResult) -> Void) -> ImageDataLoaderTask
}

extension ImageDataLoader {
	func logging(_ tag: ImageDataLoaderLogTag) -> LoggingImageDataLoader {
		LoggingImageDataLoader(
			loader: self,
			logger: ImageDataLoadingLoggers.makeLogger(tag)
		)
	}
}
