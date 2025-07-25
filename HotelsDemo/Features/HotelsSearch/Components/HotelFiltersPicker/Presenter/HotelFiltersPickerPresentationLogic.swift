//
//  HotelFiltersPickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol HotelFiltersPickerPresentationLogic {
	func presentSelectedFilter(response: HotelFiltersPickerModels.Select.Response)
	func presentResetFilter(response: HotelFiltersPickerModels.Reset.Response)
}
