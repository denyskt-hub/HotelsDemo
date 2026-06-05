//
//  ImageDataLoaderAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/8/25.
//

import Foundation
import ImageLoadingKit

@MainActor
public final class ImageDataLoaderAdapter: ImageViewDelegate {
	private let loader: ImageDataLoader
	private let presenter: ImageDataPresentationLogic

	/// Stored synchronously on the main actor: the task created by
	/// `didSetImageWith` is registered atomically with its creation, so a
	/// subsequent `didCancel`/`didSetImageWith` can never observe (and
	/// cancel) a stale task or miss an in-flight one.
	private var task: Task<Void, Never>?

	public init(
		loader: ImageDataLoader,
		presenter: ImageDataPresentationLogic
	) {
		self.loader = loader
		self.presenter = presenter
	}

	public func didSetImageWith(_ url: URL) {
		task?.cancel()
		task = Task {
			presenter.presentLoading(true)

			do {
				let data = try await loader.load(url: url)
				presenter.presentImageData(data)
			} catch is CancellationError {
				// silence cancellation
			} catch {
				presenter.presentImageDataError(error)
			}

			presenter.presentLoading(false)
		}
	}

	public func didCancel() {
		task?.cancel()
		task = nil
	}
}
