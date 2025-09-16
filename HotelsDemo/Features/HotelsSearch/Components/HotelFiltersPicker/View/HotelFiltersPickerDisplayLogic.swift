//
//  HotelFiltersPickerDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol HotelFiltersPickerDisplayLogic: AnyObject {
	func display(viewModel: HotelFiltersPickerModels.FetchFilters.ViewModel)
	func displaySelectedFilters(viewModel: HotelFiltersPickerModels.FilterSelection.ViewModel)
	func displayResetFilters(viewModel: HotelFiltersPickerModels.FilterReset.ViewModel)
}
