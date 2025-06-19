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
}
