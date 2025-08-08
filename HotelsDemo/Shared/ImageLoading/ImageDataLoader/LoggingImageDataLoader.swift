//
//  LoggingImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation

public final class LoggingImageDataLoader: ImageDataLoader {
	private let loader: ImageDataLoader
	private let logger: ImageDataLoadingLogger

	public init(
		loader: ImageDataLoader,
		logger: ImageDataLoadingLogger
	) {
		self.loader = loader
		self.logger = logger
	}

	@discardableResult
	public func load(url: URL, completion: @escaping LoadCompletion) -> ImageDataLoaderTask {
		#if DEBUG
		loader.load(url: url) { result in
			self.logger.log(loadResult: result, for: url)
			completion(result)
		}
		#else
		loader.load(url: url, completion: completion)
		#endif
	}
}
