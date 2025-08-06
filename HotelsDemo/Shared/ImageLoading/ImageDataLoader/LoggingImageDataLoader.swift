//
//  LoggingImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation

public final class LoggingImageDataLoader: ImageDataLoader {
	private let loader: ImageDataLoader
	private let tag: String

	public init(
		loader: ImageDataLoader,
		tag: String
	) {
		self.loader = loader
		self.tag = tag
	}

	@discardableResult
	public func load(url: URL, completion: @escaping LoadCompletion) -> ImageDataLoaderTask {
		#if DEBUG
		loader.load(url: url) { result in
			self.log(url, result)
			completion(result)
		}
		#else
		loader.load(url: url, completion: completion)
		#endif
	}

	private func log(_ url: URL, _ result: ImageDataLoader.LoadResult) {
		switch result {
		case .success: Logger.log("success: \(url.lastPathComponent)", tag: .custom(tag))
		case .failure: Logger.log("failure: \(url.lastPathComponent)", tag: .custom(tag))
		}
	}
}
