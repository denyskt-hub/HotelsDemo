//
//  ImagePrefetcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/8/25.
//

import Foundation
import Synchronization

public final class ImageDataPrefetcher: Sendable {
	private let loader: ImageDataLoader
	private let tasks = Mutex<[URL: Task<Void, Never>]>([:])

	public init(loader: ImageDataLoader) {
		self.loader = loader
	}

	public func prefetch(urls: [URL]) {
		for url in urls where tasks.withLock({ $0[url] }) == nil {
			tasks.withLock {
				$0[url] = Task { [weak self] in
					guard let self else { return }
					_ = try? await self.loader.load(url: url)
					self.removeTask(for: url)
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
