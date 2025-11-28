//
//  ImageDataLoaderAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/8/25.
//

import Foundation
import Synchronization

public final class ImageDataLoaderAdapter: ImageViewDelegate {
	private let loader: ImageDataLoader
	private let presenter: ImageDataPresentationLogic
	private let task = Mutex<Task<Void, Never>?>(nil)

	public init(
		loader: ImageDataLoader,
		presenter: ImageDataPresentationLogic
	) {
		self.loader = loader
		self.presenter = presenter
	}

	public func didSetImageWith(_ url: URL) {
		task.withLock { task in
			task?.cancel()
			task = Task {
				await presenter.presentLoading(true)

				do {
					let data = try await loader.load(url: url)
					await presenter.presentImageData(data)
				} catch is CancellationError {
					// silence cancellation
				} catch {
					await presenter.presentImageDataError(error)
				}

				await presenter.presentLoading(false)
			}
		}
	}

	public func didCancel() {
		task.withLock { task in
			task?.cancel()
			task = nil
		}
	}
}
