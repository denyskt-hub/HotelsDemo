//
//  ImageDataLoader+Logging.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/6/26.
//

import Foundation
import ImageLoadingKit

extension ImageDataLoader {
	func logging(_ tag: ImageDataLoaderLogTag) -> LoggingImageDataLoader {
		LoggingImageDataLoader(
			loader: self,
			logger: ImageDataLoadingLoggers.makeLogger(tag)
		)
	}
}
