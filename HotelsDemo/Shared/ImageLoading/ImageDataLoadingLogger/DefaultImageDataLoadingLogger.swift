//
//  DefaultImageDataLoadingLogger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 7/8/25.
//

import Foundation

public struct DefaultImageDataLoadingLogger: ImageDataLoadingLogger {
	private let tag: LogTag

	public init(tag: LogTag) {
		self.tag = tag
	}

	public func log(loadResult result: ImageDataLoader.LoadResult, for url: URL) {
		switch result {
		case .success:
			Logger.log("✅ success: \(url.lastPathComponent)", level: .info, tag: tag)
		case let .failure(error):
			Logger.log("failure: \(url.lastPathComponent) \(error)", level: .error, tag: tag)
		}
	}
}
