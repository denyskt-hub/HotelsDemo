//
//  DateRangePickerDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/6/25.
//

import Foundation

public protocol DateRangePickerDisplayLogic: AnyObject {
	func display(viewModel: DateRangePickerModels.Load.ViewModel)
	func displaySelectDate(viewModel: DateRangePickerModels.DateSelection.ViewModel)
	func displaySelectedDateRange(viewModel: DateRangePickerModels.Select.ViewModel)
}
