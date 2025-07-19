//
//  HotelsSearchDisplayLogicAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

public final class HotelsSearchDisplayLogicAdapter: HotelsSearchDisplayLogic {
	private weak var viewController: HotelsSearchViewController?
	private let imageDataLoader: ImageDataLoader

	public init(
		viewController: HotelsSearchViewController,
		imageLoader: ImageDataLoader
	) {
		self.viewController = viewController
		self.imageDataLoader = imageLoader
	}

	public func displaySearch(viewModel: HotelsSearchModels.Search.ViewModel) {
		guard let viewController = viewController else { return }

		let hotels = viewModel.hotels.map {
			let view = HotelCellController(viewModel: $0)
			let adapter = HotelPhotoLoaderAdapter(loader: imageDataLoader)
			let presenter = ImageDataPresenter()

			view.delegate = adapter
			adapter.presenter = presenter
			presenter.view = view
			return view
		}

		viewController.display(hotels)
	}

	public func displaySearchError(viewModel: HotelsSearchModels.ErrorViewModel) {
		guard let viewController = viewController else { return }
		viewController.displaySearchError(viewModel: viewModel)
	}
}
