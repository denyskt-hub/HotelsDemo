//
//  ImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import Foundation
import Synchronization

public protocol ImageDataLoaderTask: Sendable {
	func cancel()
}

public protocol ImageDataLoader: Sendable {
	typealias LoadResult = Result<Data, Error>

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	@discardableResult
	@available(*, deprecated, message: "Use async version")
	func load(url: URL, completion: @Sendable @escaping (LoadResult) -> Void) -> ImageDataLoaderTask

	func load(url: URL) async throws -> Data
}

extension ImageDataLoader {
	public func load(url: URL) async throws -> Data {
		let task = Mutex<ImageDataLoaderTask?>(nil)
		return try await withTaskCancellationHandler(
			operation: {
				try await withCheckedThrowingContinuation { continuation in
					task.withLock {
						$0 = self.load(url: url) { result in
							switch result {
							case .success(let data):
								continuation.resume(returning: data)
							case .failure(let error):
								continuation.resume(throwing: error)
							}
						}
					}
				}
			},
			onCancel: {
				task.withLock({ $0 })?.cancel()
			})
	}
}

extension ImageDataLoader {
	func logging(_ tag: ImageDataLoaderLogTag) -> LoggingImageDataLoader {
		LoggingImageDataLoader(
			loader: self,
			logger: ImageDataLoadingLoggers.makeLogger(tag)
		)
	}
}
