//
//  DateRangeSelection.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 29/6/25.
//

import Foundation

public struct DateRangeSelection {
	public let startDate: Date?
	public let endDate: Date?

	public init(
		startDate: Date? = nil,
		endDate: Date? = nil
	) {
		self.startDate = startDate
		self.endDate = endDate
	}

	public func selecting(_ selectedDate: Date) -> DateRangeSelection {
		switch (startDate, endDate) {
		case let (start?, nil) where selectedDate < start:
			return DateRangeSelection(startDate: selectedDate, endDate: nil)

		case let (start?, nil) where selectedDate == start:
			return DateRangeSelection(startDate: nil, endDate: nil)

		case let (start?, nil) where selectedDate > start:
			return DateRangeSelection(startDate: start, endDate: selectedDate)

		default:
			return DateRangeSelection(startDate: selectedDate, endDate: nil)
		}
	}
}

public extension DateRangeSelection {
	var canApply: Bool {
		startDate != nil && endDate != nil
	}
}
