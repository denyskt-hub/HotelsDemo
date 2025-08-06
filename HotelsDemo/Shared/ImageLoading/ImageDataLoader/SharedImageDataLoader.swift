//
//  SharedImageLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/8/25.
//

import Foundation

public enum SharedImageDataLoader {
	private static var _instance: ImageDataLoader?

	public static var instance: ImageDataLoader {
		get { _instance ?? defaultLoader() }
		set { _instance = newValue }
	}

	private static func defaultLoader() -> ImageDataLoader {
		let cache = LoggingImageDataCache(
			cache: SharedImageDataCache.instance
		)
		let dispatcher = MainQueueDispatcher()
		let local = LoggingImageDataLoader(
			loader: LocalImageDataLoader(
				cache: cache,
				dispatcher: dispatcher
			),
			tag: "local image"
		)
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
		let logging = LoggingImageDataLoader(
			loader: local.fallback(to: caching),
			tag: "image loading"
		)
		return logging
	}
}
