//
//  Date+Helpers.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/3/25.
//

import Foundation

public extension Date {
	func adding(seconds: TimeInterval) -> Date {
		self + seconds
	}

	func adding(minutes: Int, calendar: Calendar) -> Date {
		guard let date = calendar.date(byAdding: .minute, value: minutes, to: self) else {
			preconditionFailure("Unable to add \(minutes) minutes to \(self) in calendar \(calendar.identifier)")
		}
		return date
	}

	func adding(days: Int, calendar: Calendar) -> Date {
		guard let date = calendar.date(byAdding: .day, value: days, to: self) else {
			preconditionFailure("Unable to add \(days) days to \(self) in calendar \(calendar.identifier)")
		}
		return date
	}

	func adding(months: Int, calendar: Calendar) -> Date {
		guard let date = calendar.date(byAdding: .month, value: months, to: self) else {
			preconditionFailure("Unable to add \(months) months to \(self) in calendar \(calendar.identifier)")
		}
		return date
	}

	func firstDateOfMonth(calendar: Calendar) -> Date {
		var components = calendar.dateComponents([.day, .month, .year], from: self)
		components.day = 1
		guard let date = calendar.date(from: components) else {
			preconditionFailure("Unable to derive first day of month from \(self) in calendar \(calendar.identifier)")
		}
		return date
	}
}
