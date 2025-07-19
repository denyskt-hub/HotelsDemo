//
//  DateRangePickerBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/6/25.
//

import Foundation

public protocol DateRangePickerBusinessLogic {
	func load(request: DateRangePickerModels.Load.Request)
	func didSelectDate(request: DateRangePickerModels.DateSelection.Request)
	func selectDateRange(request: DateRangePickerModels.Select.Request)
}
