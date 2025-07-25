//
//  HotelFiltersPickerDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol HotelFiltersPickerDisplayLogic: AnyObject {
	func displaySelectedFilters(viewModel: HotelFiltersPickerModels.Select.ViewModel)
	func displayResetFilter(viewModel: HotelFiltersPickerModels.Reset.ViewModel)
}
