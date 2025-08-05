//
//  HotelFiltersPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public final class HotelFiltersPickerPresenter: HotelFiltersPickerPresentationLogic {
	public var viewController: HotelFiltersPickerDisplayLogic?

	public init() {
		// Required for initialization in tests
	}

	public func present(response: HotelFiltersPickerModels.Load.Response) {
		let hasSelectedFilters = !response.filters.starRatings.isEmpty ||
			response.filters.priceRange != nil ||
			response.filters.reviewScore != nil

		let viewModel = HotelFiltersPickerModels.Load.ViewModel(
			hasSelectedFilters: hasSelectedFilters
		)
		viewController?.display(viewModel: viewModel)
	}

	public func presentSelectedFilters(response: HotelFiltersPickerModels.Select.Response) {
		let viewModel = HotelFiltersPickerModels.Select.ViewModel(filters: response.filters)
		viewController?.displaySelectedFilters(viewModel: viewModel)
	}

	public func presentResetFilters(response: HotelFiltersPickerModels.Reset.Response) {
		let viewModel = HotelFiltersPickerModels.Reset.ViewModel()
		viewController?.displayResetFilters(viewModel: viewModel)
	}
}
