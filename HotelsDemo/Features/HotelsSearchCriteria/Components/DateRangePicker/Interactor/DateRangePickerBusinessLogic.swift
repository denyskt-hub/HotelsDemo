//
//  DateRangePickerBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/6/25.
//

import Foundation

public protocol DateRangePickerBusinessLogic {
	func doFetchCalendar(request: DateRangePickerModels.FetchCalendar.Request)
	func handleDateSelection(request: DateRangePickerModels.DateSelection.Request)
	func handleDateRangeSelection(request: DateRangePickerModels.DateRangeSelection.Request)
}
