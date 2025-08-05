//
//  HotelFiltersPickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol HotelFiltersPickerPresentationLogic {
	func present(response: HotelFiltersPickerModels.Load.Response)
	func presentSelectedFilters(response: HotelFiltersPickerModels.Select.Response)
	func presentResetFilters(response: HotelFiltersPickerModels.Reset.Response)
}
