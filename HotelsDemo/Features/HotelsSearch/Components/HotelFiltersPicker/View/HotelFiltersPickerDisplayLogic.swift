//
//  HotelFiltersPickerDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol HotelFiltersPickerDisplayLogic: AnyObject {
	func display(viewModel: HotelFiltersPickerModels.Load.ViewModel)
	func displaySelectedFilters(viewModel: HotelFiltersPickerModels.Select.ViewModel)
	func displayResetFilters(viewModel: HotelFiltersPickerModels.Reset.ViewModel)
}
