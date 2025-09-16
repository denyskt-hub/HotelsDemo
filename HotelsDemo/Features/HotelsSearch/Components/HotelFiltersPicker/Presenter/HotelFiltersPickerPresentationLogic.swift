//
//  HotelFiltersPickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol HotelFiltersPickerPresentationLogic {
	func present(response: HotelFiltersPickerModels.FetchFilters.Response)
	func presentSelectedFilters(response: HotelFiltersPickerModels.FilterSelection.Response)
	func presentResetFilters(response: HotelFiltersPickerModels.FilterReset.Response)
}
