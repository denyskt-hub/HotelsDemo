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
	private let task = Mutex<ImageDataLoaderTask?>(nil)

	public init(
		loader: ImageDataLoader,
		presenter: ImageDataPresentationLogic
	) {
		self.loader = loader
		self.presenter = presenter
	}

	public func didSetImageWith(_ url: URL) {
		presentLoading(true)

		task.withLock { task in
			task?.cancel()
			task = loader.load(url: url) { [weak self] result in
				guard let self else { return }

				self.presentLoading(false)
				self.handleLoadResult(result)
			}
		}
	}

	private func handleLoadResult(_ result: ImageDataLoader.LoadResult) {
		switch result {
		case let .success(data):
			presentImageData(data)
		case let .failure(error):
			presentImageDataError(error)
		}
	}

	public func didCancel() {
		task.withLock { task in
			task?.cancel()
			task = nil
		}
	}

	private func presentLoading(_ loading: Bool) {
		Task { await presenter.presentLoading(loading) }
	}

	private func presentImageData(_ data: Data) {
		Task { await presenter.presentImageData(data) }
	}

	private func presentImageDataError(_ error: Error) {
		Task { await presenter.presentImageDataError(error) }
	}
}
