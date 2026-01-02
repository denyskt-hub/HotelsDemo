//
//  ImageDataLoaderAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/8/25.
//

import Foundation

public final class ImageDataLoaderAdapter: ImageViewDelegate {
	private let loader: ImageDataLoader
	private let presenter: ImageDataPresentationLogic
	private let taskStore = TaskStore<Void, Never>()

	public init(
		loader: ImageDataLoader,
		presenter: ImageDataPresentationLogic
	) {
		self.loader = loader
		self.presenter = presenter
	}

	public func didSetImageWith(_ url: URL) {
		let task = Task {
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
		Task {
			await taskStore.setTask(task)
		}
	}

	public func didCancel() {
		Task {
			await taskStore.cancel()
		}
	}
}
