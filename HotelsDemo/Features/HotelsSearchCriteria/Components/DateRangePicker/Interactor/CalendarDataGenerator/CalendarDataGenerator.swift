//
//  CalendarDataGenerator.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 29/6/25.
//

import Foundation

public struct SelectedDateRange {
	public let startDate: Date?
	public let endDate: Date?

	public init(startDate: Date?, endDate: Date?) {
		self.startDate = startDate
		self.endDate = endDate
	}
}

public protocol CalendarDataGenerator {
	func generate(selectedRange: SelectedDateRange) -> DateRangePickerModels.CalendarData
}
