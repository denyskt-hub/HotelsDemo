//
//  SharedImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation
import Synchronization

public enum SharedImageDataCache {
	private static let _instance = Mutex(defaultCache())

	public static var instance: ImageDataCache {
		get { _instance.withLock({ $0 }) }
		set { _instance.withLock({ $0 = newValue }) }
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
