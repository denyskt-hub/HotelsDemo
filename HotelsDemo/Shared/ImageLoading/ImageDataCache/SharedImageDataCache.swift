//
//  SharedImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation

public enum SharedImageDataCache {
	private static var _instance: ImageDataCache?

	public static var instance: ImageDataCache {
		get { _instance ?? defaultCache() }
		set { _instance = newValue }
	}

	private static func defaultCache() -> ImageDataCache {
		InMemoryImageDataCache(countLimit: 100)
	}
}
