//
//  ImagePrefetcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/8/25.
//

import Foundation

public final class ImageDataPrefetcher {
	private let queue = DispatchQueue(label: "\(ImageDataPrefetcher.self)Queue")

	private let loader: ImageDataLoader
	private var tasks = [URL: ImageDataLoaderTask]()

	public init(loader: ImageDataLoader) {
		self.loader = loader
	}

	public func prefetch(urls: [URL]) {
		queue.async { [weak self] in
			guard let self else { return }

			for url in urls where self.tasks[url] == nil {
				self.tasks[url] = loader.load(url: url) { _ in
					self.tasks[url] = nil
				}
			}
		}
	}

	public func cancelPrefetching(urls: [URL]) {
		queue.async { [weak self] in
			guard let self else { return }

			for url in urls {
				self.tasks[url]?.cancel()
				self.tasks[url] = nil
			}
		}
	}
}
