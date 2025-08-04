//
//  SharedImageLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/8/25.
//

import Foundation

enum SharedImageDataLoader {
	private static var _instance: ImageDataLoader?

	public static var instance: ImageDataLoader {
		get { _instance ?? defaultLoader() }
		set { _instance = newValue }
	}

	private static func defaultLoader() -> ImageDataLoader {
		let cache = InMemoryImageDataCache(countLimit: 100)
		let dispatcher = MainQueueDispatcher()
		let local = LocalImageDataLoader(
			cache: cache,
			dispatcher: dispatcher
		)
		let remote = RemoteImageDataLoader(
			client: URLSessionHTTPClient.shared,
			dispatcher: dispatcher
		)
		let caching = CachingImageDataLoader(
			loader: remote,
			cache: cache
		)
		return local.fallback(to: caching)
	}
}
