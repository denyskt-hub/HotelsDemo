//
//  SharedImageLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/8/25.
//

import Foundation

public enum SharedImageDataLoader {
	private static var _instance: ImageDataLoader = defaultLoader()

	public static var instance: ImageDataLoader {
		get { _instance }
		set { _instance = newValue }
	}

	private static func defaultLoader() -> ImageDataLoader {
		let cache = LoggingImageDataCache(
			cache: SharedImageDataCache.instance,
			logger: ImageDataCacheLoggers.makeLogger(.cache)
		)
		let local = LoggingImageDataLoader(
			loader: LocalImageDataLoader(
				cache: cache,
				dispatcher: MainQueueDispatcher()
			),
			logger: ImageDataLoadingLoggers.makeLogger(.local)
		)
		let remote = LoggingImageDataLoader(
			loader: RemoteImageDataLoader.shared,
			logger: ImageDataLoadingLoggers.makeLogger(.remote)
		)
		let caching = CachingImageDataLoader(
			loader: remote,
			cache: cache
		)
		let logging = LoggingImageDataLoader(
			loader: local.fallback(to: caching),
			logger: ImageDataLoadingLoggers.makeLogger(.composite)
		)
		return logging
	}

	public static func configureLogging(enabled: Bool = true) {
		let tags: [ImageDataLoaderLogTag] = [.local, .remote, .composite]

		tags.forEach { tag in
			if enabled {
				Logger.enableTag(tag.tag)
			} else {
				Logger.disableTag(tag.tag)
			}
		}
	}
}
