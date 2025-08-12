//
//  DefaultImageDataCacheLogger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 7/8/25.
//

import Foundation

public struct DefaultImageDataCacheLogger: ImageDataCacheLogger {
	private let tag: LogTag

	public init(tag: LogTag) {
		self.tag = tag
	}

	public func log(saveResult result: ImageDataCache.SaveResult, forKey key: String) {
		switch result {
		case .success:
			Logger.log("✅ Save success for key: \(key)", level: .info, tag: tag)
		case let .failure(error):
			Logger.log("Save failure with \(error) for key: \(key)", level: .error, tag: tag)
		}
	}

	public func log(dataResult result: ImageDataCache.DataResult, forKey key: String) {
		switch result {
		case let .success(data):
			if let data = data {
				Logger.log("✅ Load success for key: \(key) (\(data.count) bytes)", level: .info, tag: .custom("cache"))
			} else {
				Logger.log("Loaded nil data for key: \"\(key)\"", level: .warning, tag: .custom("cache"))
			}
		case let .failure(error):
			Logger.log("Load failure with \(error) for key: \(key)", level: .error, tag: .custom("cache"))
		}
	}
}
