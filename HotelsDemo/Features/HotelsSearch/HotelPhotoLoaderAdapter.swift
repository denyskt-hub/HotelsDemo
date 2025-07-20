//
//  HotelCellImageLoaderAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import Foundation

public final class HotelPhotoLoaderAdapter: HotelCellControllerDelegate {
	private let loader: ImageDataLoader
	private var task: ImageDataLoaderTask?

	public var presenter: ImageDataPresentationLogic?

	public init(loader: ImageDataLoader) {
		self.loader = loader
	}

	public func didRequestPhoto(_ url: URL) {
		presenter?.presentLoading(true)
		task = loader.load(url: url) { [weak self] result in
			self?.presenter?.presentLoading(false)
			self?.handleLoadResult(result)
		}
	}

	private func handleLoadResult(_ result: ImageDataLoader.LoadResult) {
		switch result {
		case let .success(data):
			presenter?.presentImageData(data)
		case let .failure(error):
			presenter?.presentImageDataError(error)
		}
	}

	public func didCancelPhotoRequest() {
		task?.cancel()
	}
}
