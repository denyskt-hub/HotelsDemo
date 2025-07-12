//
//  DefaultSearchCriteriaValidator.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DefaultSearchCriteriaValidator: SearchCriteriaValidator {
	private let calendar: Calendar
	private let currentDate: () -> Date

	public init(
		calendar: Calendar,
		currentDate: @escaping () -> Date
	) {
		self.calendar = calendar
		self.currentDate = currentDate
	}

	public func validate(_ criteria: SearchCriteria) -> SearchCriteria {
		let today = calendar.startOfDay(for: currentDate())
		let minCheckIn = today

		var checkIn = criteria.checkInDate
		var checkOut = criteria.checkOutDate

		if checkIn < minCheckIn {
			checkIn = minCheckIn.adding(days: 1, calendar: calendar)
		}
		if checkOut <= checkIn {
			checkOut = checkIn.adding(days: 1, calendar: calendar)
		}

		return SearchCriteria(
			destination: criteria.destination,
			checkInDate: checkIn,
			checkOutDate: checkOut,
			adults: criteria.adults,
			childrenAge: criteria.childrenAge,
			roomsQuantity: criteria.roomsQuantity
		)
	}
}
