//
//  SharedImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation

public enum SharedImageDataCache {
	private static var _instance: ImageDataCache = defaultCache()

	public static var instance: ImageDataCache {
		get { _instance }
		set { _instance = newValue }
	}

	private static func defaultCache() -> ImageDataCache {
		InMemoryImageDataCache(countLimit: 100)
	}

	public static func configureLogging(enabled: Bool = true) {
		ImageDataCacheLogTag.allCases.forEach { tag in
			if enabled {
				Logger.enableTag(tag.tag)
			} else {
				Logger.disableTag(tag.tag)
			}
		}
	}
}
