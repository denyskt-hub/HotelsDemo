//
//  SharedImageDataPrefetcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 6/8/25.
//

import Foundation

public enum SharedImageDataPrefetcher {
	private static var _instance: ImageDataPrefetcher?

	public static var instance: ImageDataPrefetcher {
		get { _instance ?? defaultPrefetcher() }
		set { _instance = newValue }
	}

	private static func defaultPrefetcher() -> ImageDataPrefetcher {
		let cache = LoggingImageDataCache(
			cache: SharedImageDataCache.instance
		)
		let dispatcher = MainQueueDispatcher()
		let remote = LoggingImageDataLoader(
			loader: RemoteImageDataLoader(
				client: URLSessionHTTPClient.shared,
				dispatcher: dispatcher
			),
			tag: "remote image"
		)
		let caching = CachingImageDataLoader(
			loader: remote,
			cache: cache
		)
		let prefetching = LoggingImageDataLoader(
			loader: PrefetchingImageDataLoader(
				loader: caching,
				cache: cache,
				dispatcher: dispatcher
			),
			tag: "prefetch image"
		)
		return ImageDataPrefetcher(loader: prefetching)
	}
}
