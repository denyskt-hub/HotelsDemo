//
//  SharedImageDataPrefetcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation

public enum SharedImageDataPrefetcher {
	public static let instance = defaultPrefetcher()

	private static func defaultPrefetcher() -> ImageDataPrefetcher {
		let cache = SharedImageDataCache.instance.logging(.cache)
		let local = LocalImageDataLoader(cache: cache)
		let remote = RemoteImageDataLoader.shared.logging(.remote)
		let caching = CachingImageDataLoader(loader: remote, cache: cache)
		let prefetching = local.fallback(to: caching).logging(.prefetch)
		return DefaultImageDataPrefetcher(loader: prefetching)
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
