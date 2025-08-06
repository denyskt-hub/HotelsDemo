//
//  ImagePrefetcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/8/25.
//

import Foundation

public final class ImageDataPrefetcher {
	private let loader: ImageDataLoader
	private var tasks = [URL: ImageDataLoaderTask]()

	public init(loader: ImageDataLoader) {
		self.loader = loader
	}

	public func prefetch(urls: [URL]) {
		for url in urls where tasks[url] == nil {
			tasks[url] = loader.load(url: url) { [weak self] _ in
				self?.tasks[url] = nil
			}
		}
	}

	public func cancelPrefetching(urls: [URL]) {
		for url in urls {
			tasks[url]?.cancel()
			tasks[url] = nil
		}
	}
}
