//
//  Date+Helpers.swift
//  DemoAppFeaturesTests
//
//  Created by Denys Kotenko on 19/3/25.
//

import Foundation

extension Date {
	func adding(seconds: TimeInterval) -> Date {
		self + seconds
	}

	func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
		calendar.date(byAdding: .minute, value: minutes, to: self)!
	}

	func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
		calendar.date(byAdding: .day, value: days, to: self)!
	}

	func adding(months: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
		calendar.date(byAdding: .month, value: months, to: self)!
	}

	func firstDateOfMonth(calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
		var components = calendar.dateComponents([.day, .month, .year], from: self)
		components.day = 1
		return calendar.date(from: components)!
	}
}
