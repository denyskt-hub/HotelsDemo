//
//  FallbackImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

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
		private var isCancelled = false
		var primaryTask: ImageDataLoaderTask?
		var secondaryTask: ImageDataLoaderTask?

		public func cancel() {
			isCancelled = true
			primaryTask?.cancel()
			secondaryTask?.cancel()
		}

		public func completeIfNotCancelled(_ result: LoadResult, _ completion: @escaping (LoadResult) -> Void) {
			guard !isCancelled else { return }
			completion(result)
		}
	}

	@discardableResult
	public func load(url: URL, completion: @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		let task = FallbackImageDataLoaderTaskWrapper()

		task.primaryTask = primary.load(url: url) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(data):
				completion(.success(data))
			case .failure:
				task.secondaryTask = self.secondary.load(url: url) { result in
					task.completeIfNotCancelled(result, completion)
				}
			}
		}

		return task
	}
}

public extension ImageDataLoader {
	func fallback(to secondary: ImageDataLoader) -> ImageDataLoader {
		FallbackImageDataLoader(primary: self, secondary: secondary)
	}
}
