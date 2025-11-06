//
//  FallbackImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation
import Synchronization

public final class FallbackImageDataLoader: ImageDataLoader {
	private let primary: ImageDataLoader
	private let secondary: ImageDataLoader

	public init(
		primary: ImageDataLoader,
		secondary: ImageDataLoader
	) {
		self.primary = primary
		self.secondary = secondary
	}

	private final class FallbackImageDataLoaderTaskWrapper: ImageDataLoaderTask {
		private let isCancelled = Mutex<Bool>(false)
		private let primaryTask = Mutex<ImageDataLoaderTask?>(nil)
		private let secondaryTask = Mutex<ImageDataLoaderTask?>(nil)

		public func setPrimaryTask(_ task: ImageDataLoaderTask) {
			primaryTask.withLock { $0 = task }
		}

		public func setSecondaryTask(_ task: ImageDataLoaderTask) {
			secondaryTask.withLock { $0 = task }
		}

		public func cancel() {
			isCancelled.withLock { $0 = true }
			primaryTask.withLock { $0?.cancel() }
			secondaryTask.withLock { $0?.cancel() }
		}

		public func completeIfNotCancelled(_ result: LoadResult, _ completion: @escaping (LoadResult) -> Void) {
			guard !isCancelled.withLock({ $0 }) else { return }
			completion(result)
		}
	}

	@discardableResult
	public func load(url: URL, completion: @Sendable @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		let task = FallbackImageDataLoaderTaskWrapper()

		task.setPrimaryTask(primary.load(url: url) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(data):
				completion(.success(data))
			case .failure:
				task.setSecondaryTask(self.secondary.load(url: url) { result in
					task.completeIfNotCancelled(result, completion)
				})
			}
		})

		return task
	}
}

public extension ImageDataLoader {
	func fallback(to secondary: ImageDataLoader) -> ImageDataLoader {
		FallbackImageDataLoader(primary: self, secondary: secondary)
	}
}
