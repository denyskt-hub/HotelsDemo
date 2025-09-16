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

	public func present(response: HotelFiltersPickerModels.FetchFilters.Response) {
		let viewModel = HotelFiltersPickerModels.FetchFilters.ViewModel(
			hasSelectedFilters: response.filters.hasSelectedFilters
		)
		viewController?.display(viewModel: viewModel)
	}

	public func presentSelectedFilters(response: HotelFiltersPickerModels.FilterSelection.Response) {
		let viewModel = HotelFiltersPickerModels.FilterSelection.ViewModel(filters: response.filters)
		viewController?.displaySelectedFilters(viewModel: viewModel)
	}

	public func presentResetFilters(response: HotelFiltersPickerModels.FilterReset.Response) {
		let viewModel = HotelFiltersPickerModels.FilterReset.ViewModel()
		viewController?.displayResetFilters(viewModel: viewModel)
	}
}
