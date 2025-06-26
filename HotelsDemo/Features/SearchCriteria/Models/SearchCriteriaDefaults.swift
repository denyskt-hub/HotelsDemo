//
//  SearchCriteriaDefaults.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/6/25.
//

import Foundation

public struct SearchCriteriaDefaults {
	public static func make(
		calendar: Calendar,
		currentDate: @escaping () -> Date
	) -> SearchCriteria {
		let today = calendar.startOfDay(for: currentDate())
		let minCheckIn = today.adding(days: 1, calendar: calendar)
		let minCheckOut = minCheckIn.adding(days: 1, calendar: calendar)

		return SearchCriteria(
			destination: nil,
			checkInDate: minCheckIn,
			checkOutDate: minCheckOut,
			adults: 2,
			childrenAge: [],
			roomsQuantity: 1
		)
	}
}
