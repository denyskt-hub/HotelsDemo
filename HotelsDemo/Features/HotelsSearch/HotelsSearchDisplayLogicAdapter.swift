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
		display(viewModel.hotels)
	}

	public func displayLoading(viewModel: HotelsSearchModels.LoadingViewModel) {
		viewController?.displayLoading(viewModel: viewModel)
	}

	public func displaySearchError(viewModel: HotelsSearchModels.ErrorViewModel) {
		viewController?.displaySearchError(viewModel: viewModel)
	}

	public func displayFilter(viewModel: HotelsSearchModels.Filter.ViewModel) {
		viewController?.displayFilter(viewModel: viewModel)
	}

	public func displayUpdateFilter(viewModel: HotelsSearchModels.UpdateFilter.ViewModel) {
		display(viewModel.hotels)
	}

	private func display(_ hotels: [HotelsSearchModels.HotelViewModel]) {
		guard let viewController = viewController else { return }

		let hotels = hotels.map { HotelCellController(viewModel: $0) }

		viewController.display(hotels)
	}
}
