//
//  ImageDataCacheLoggers.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 7/8/25.
//

import Foundation

public enum ImageDataCacheLoggers {
	static func makeLogger(_ loggerTag: ImageDataCacheLogTag) -> ImageDataCacheLogger {
		DefaultImageDataCacheLogger(tag: loggerTag.tag)
	}
}

public enum ImageDataCacheLogTag: CaseIterable {
	case cache

	var tag: LogTag {
		.custom(rawValue)
	}

	private var rawValue: String {
		switch self {
		case .cache: return "cache"
		}
	}
}
