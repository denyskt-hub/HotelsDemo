//
//  Calendar.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/6/25.
//

import Foundation

extension Calendar {
	static func gregorian(
		timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!,
		locale: Locale = Locale(identifier: "en_US_POSIX")
	) -> Calendar {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = timeZone
		calendar.locale = locale
		return calendar
	}
}
