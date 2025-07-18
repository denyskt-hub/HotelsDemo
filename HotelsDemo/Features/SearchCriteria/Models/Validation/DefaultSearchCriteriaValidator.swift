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
		let (checkIn, checkOut) = validate(
			checkIn: criteria.checkInDate,
			checkOut: criteria.checkOutDate,
			currentDate: currentDate,
			calendar: calendar
		)

		let adults = validate(
			adults: criteria.adults,
			minValue: SearchLimits.minAdults,
			maxValue: SearchLimits.maxAdults
		)
		let childrenAge = validate(
			childrenAge: criteria.childrenAge,
			minValue: SearchLimits.minChildAge,
			maxValue: SearchLimits.maxChildAge
		)
		let roomsQuantity = validate(
			roomsQuantity: criteria.roomsQuantity,
			minValue: SearchLimits.minRooms,
			maxValue: SearchLimits.maxRooms
		)

		return SearchCriteria(
			destination: criteria.destination,
			checkInDate: checkIn,
			checkOutDate: checkOut,
			adults: adults,
			childrenAge: childrenAge,
			roomsQuantity: roomsQuantity
		)
	}

	private func validate(
		checkIn: Date,
		checkOut: Date,
		currentDate: () -> Date,
		calendar: Calendar
	) -> (checkIn: Date, checkOut: Date) {
		let today = calendar.startOfDay(for: currentDate())
		let minCheckIn = today

		var checkIn = checkIn
		var checkOut = checkIn

		if checkIn < minCheckIn {
			checkIn = minCheckIn.adding(days: 1, calendar: calendar)
		}
		if checkOut <= checkIn {
			checkOut = checkIn.adding(days: 1, calendar: calendar)
		}

		return (checkIn, checkOut)
	}

	private func validate(adults: Int, minValue: Int, maxValue: Int) -> Int {
		clamp(adults, minValue: minValue, maxValue: maxValue)
	}

	private func validate(childrenAge: [Int], minValue: Int, maxValue: Int) -> [Int] {
		childrenAge.map {
			clamp($0, minValue: minValue, maxValue: maxValue)
		}
	}

	private func validate(roomsQuantity: Int, minValue: Int, maxValue: Int) -> Int {
		clamp(roomsQuantity, minValue: minValue, maxValue: maxValue)
	}

	private func clamp(_ value: Int, minValue: Int, maxValue: Int) -> Int {
		min(max(value, minValue), maxValue)
	}
}
