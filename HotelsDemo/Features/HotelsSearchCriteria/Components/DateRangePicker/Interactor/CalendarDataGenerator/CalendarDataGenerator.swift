//
//  CalendarDataGenerator.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 29/6/25.
//

import Foundation

public protocol CalendarDataGenerator {
	func generate(selectedRange: SelectedDateRange) -> DateRangePickerModels.CalendarData
}
