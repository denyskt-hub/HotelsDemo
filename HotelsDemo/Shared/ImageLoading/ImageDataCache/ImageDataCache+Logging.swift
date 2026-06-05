//
//  ImageDataCache+Logging.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/6/26.
//

import Foundation
import ImageLoadingKit

public extension ImageDataCache {
	typealias SaveResult = Result<Void, Error>
	typealias DataResult = Result<Data?, Error>
}

extension ImageDataCache {
	func logging(_ tag: ImageDataCacheLogTag) -> LoggingImageDataCache {
		LoggingImageDataCache(
			cache: self,
			logger: ImageDataCacheLoggers.makeLogger(tag)
		)
	}
}
