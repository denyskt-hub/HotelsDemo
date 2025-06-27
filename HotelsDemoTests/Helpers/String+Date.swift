//
//  String+Date.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/6/25.
//

import Foundation

extension String {
	func date(
		format: String = "dd.MM.yyyy",
		timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!,
		locale: Locale = Locale(identifier: "en_US_POSIX")
	) -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatter.timeZone = timeZone
		formatter.locale = locale
		guard let date = formatter.date(from: self) else {
			preconditionFailure("Invalid date string: \(self)")
		}
		return date
	}
}
