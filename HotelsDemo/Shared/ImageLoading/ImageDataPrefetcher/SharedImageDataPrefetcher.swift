//
//  SharedImageDataPrefetcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation

public enum SharedImageDataPrefetcher {
	private static var _instance: ImageDataPrefetcher = defaultPrefetcher()

	public static var instance: ImageDataPrefetcher {
		get { _instance }
		set { _instance = newValue }
	}

	private static func defaultPrefetcher() -> ImageDataPrefetcher {
		let cache = LoggingImageDataCache(
			cache: SharedImageDataCache.instance,
			logger: ImageDataCacheLoggers.makeLogger(.cache)
		)
		let remote = LoggingImageDataLoader(
			loader: RemoteImageDataLoader.shared,
			logger: ImageDataLoadingLoggers.makeLogger(.remote)
		)
		let caching = CachingImageDataLoader(
			loader: remote,
			cache: cache
		)
		let prefetching = LoggingImageDataLoader(
			loader: PrefetchingImageDataLoader(
				loader: caching,
				cache: cache,
				dispatcher: MainQueueDispatcher()
			),
			logger: ImageDataLoadingLoggers.makeLogger(.prefetch)
		)
		return ImageDataPrefetcher(loader: prefetching)
	}

	public static func configureLogging(enabled: Bool = true) {
		let tags: [ImageDataLoaderLogTag] = [.remote, .prefetch]

		tags.forEach { tag in
			if enabled {
				Logger.enableTag(tag.tag)
			} else {
				Logger.disableTag(tag.tag)
			}
		}
	}
}
