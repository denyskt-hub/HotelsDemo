//
//  DateRangePickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/6/25.
//

import Foundation

public protocol DateRangePickerPresentationLogic {
	func present(response: DateRangePickerModels.Load.Response)
	func presentSelectDate(response: DateRangePickerModels.DateSelection.Response)
	func presentSelectedDateRange(response: DateRangePickerModels.Select.Response)
}
