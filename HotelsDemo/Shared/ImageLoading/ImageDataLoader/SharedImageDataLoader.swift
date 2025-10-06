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
		let cache = SharedImageDataCache.instance.logging(.cache)
		let local = LocalImageDataLoader(cache: cache).logging(.local)
		let remote = RemoteImageDataLoader.shared.logging(.remote)
		let caching = CachingImageDataLoader(loader: remote, cache: cache)
		let logging = local.fallback(to: caching).logging(.composite)
		return logging.dispatch(to: MainQueueDispatcher())
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
