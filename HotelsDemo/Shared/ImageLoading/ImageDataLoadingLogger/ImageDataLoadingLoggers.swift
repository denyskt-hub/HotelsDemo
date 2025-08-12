//
//  ImageDataLoadingLoggers.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 7/8/25.
//

import Foundation

public enum ImageDataLoadingLoggers {
	static func makeLogger(_ loggerTag: ImageDataLoaderLogTag) -> ImageDataLoadingLogger {
		DefaultImageDataLoadingLogger(tag: loggerTag.tag)
	}
}

public enum ImageDataLoaderLogTag: CaseIterable {
	case local
	case remote
	case prefetch
	case composite

	var tag: LogTag {
		.custom(rawValue)
	}

	private var rawValue: String {
		switch self {
		case .local: return "local image"
		case .remote: return "remote image"
		case .prefetch: return "prefetch image"
		case .composite: return "image loading"
		}
	}
}
