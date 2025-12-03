//
//  ImagePrefetcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/8/25.
//

import Foundation
import Synchronization

public final class DefaultImageDataPrefetcher: ImageDataPrefetcher {
	private let loader: ImageDataLoader
	private let delegate: ImageDataPrefetcherDelegate?
	private let tasks = Mutex<[URL: Task<Void, Never>]>([:])

	public init(
		loader: ImageDataLoader,
		delegate: ImageDataPrefetcherDelegate? = nil
	) {
		self.loader = loader
		self.delegate = delegate
	}

	public func prefetch(urls: [URL]) {
		for url in urls where tasks.withLock({ $0[url] }) == nil {
			tasks.withLock {
				$0[url] = Task { [weak self] in
					guard let self else { return }
					self.delegate?.imageDataPrefetcher(self, willPrefetchDataForURL: url)

					_ = try? await self.loader.load(url: url)
					self.removeTask(for: url)

					self.delegate?.imageDataPrefetcher(self, didPrefetchDataForURL: url)
				}
			}
		}
	}

	private func removeTask(for url: URL) {
		tasks.withLock { $0[url] = nil }
	}

	public func cancelPrefetching(urls: [URL]) {
		for url in urls {
			tasks.withLock {
				$0[url]?.cancel()
				$0[url] = nil
			}
		}
	}
}
