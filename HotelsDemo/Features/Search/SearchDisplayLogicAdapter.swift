//
//  SearchDisplayLogicAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

public final class SearchDisplayLogicAdapter: SearchDisplayLogic {
	private weak var viewController: SearchViewController?
	private let imageDataLoader: ImageDataLoader

	public init(
		viewController: SearchViewController,
		imageLoader: ImageDataLoader
	) {
		self.viewController = viewController
		self.imageDataLoader = imageLoader
	}

	public func displaySearch(viewModel: SearchModels.Search.ViewModel) {
		guard let viewController = viewController else { return }

		let hotels = viewModel.hotels.map {
			let view = HotelCellController(viewModel: $0)
			let adapter = ImageDataPresentationAdapter(loader: imageDataLoader)
			let presenter = ImageDataPresenter()

			view.delegate = adapter
			adapter.presenter = presenter
			presenter.view = view
			return view
		}

		viewController.display(hotels)
	}
	
	public func displaySearchError(viewModel: SearchModels.ErrorViewModel) {
		guard let viewController = viewController else { return }
		viewController.displaySearchError(viewModel: viewModel)
	}
}

public final class ImageDataPresentationAdapter: HotelCellControllerDelegate {
	private let loader: ImageDataLoader
	private var task: ImageDataLoaderTask?

	public var presenter: ImageDataPresenter?

	public init(loader: ImageDataLoader) {
		self.loader = loader
	}

	public func didRequestPhoto(_ url: URL) {
		task = loader.load(url: url) { [weak self] result in
			if case let .success(data) = result {
				self?.presenter?.presentImageData(data)
			}
		}
	}

	public func didCancelPhotoRequest() {
		task?.cancel()
	}
}

public protocol ImageView: AnyObject {
	func displayImage(_ image: UIImage)
}

public final class ImageDataPresenter {
	public weak var view: ImageView?

	public func presentImageData(_ data: Data) {
		guard let image = UIImage(data: data) else { return }
		view?.displayImage(image)
	}
}
