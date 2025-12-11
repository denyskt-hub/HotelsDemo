//
//  HotelsSearchDisplayLogicAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

@MainActor
public final class HotelsSearchDisplayLogicAdapter: HotelsSearchDisplayLogic {
	private let viewController: HotelsDisplayLogic

	public init(viewController: HotelsDisplayLogic) {
		self.viewController = viewController
	}

	public func displaySearch(viewModel: HotelsSearchModels.Search.ViewModel) {
		display(viewModel.hotels)
	}

	public func displayLoading(viewModel: HotelsSearchModels.LoadingViewModel) {
		viewController.displayLoading(viewModel.isLoading)
	}

	public func displaySearchError(viewModel: HotelsSearchModels.ErrorViewModel) {
		viewController.displayErrorMessage(viewModel.message)
	}

	public func displayFilters(viewModel: HotelsSearchModels.FetchFilters.ViewModel) {
		viewController.displayFilters(viewModel.filters)
	}

	public func displayUpdateFilters(viewModel: HotelsSearchModels.FilterSelection.ViewModel) {
		display(viewModel.hotels)
		viewController.displayFiltersBadge(viewModel.hasSelectedFilters)
	}

	private func display(_ hotels: [HotelsSearchModels.HotelViewModel]) {
		let hotels = hotels.map { HotelCellController(viewModel: $0) }

		viewController.displayCellControllers(hotels)
	}
}
