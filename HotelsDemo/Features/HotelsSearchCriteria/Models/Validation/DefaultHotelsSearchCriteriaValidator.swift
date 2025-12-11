//
//  DefaultHotelsSearchCriteriaValidator.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DefaultHotelsSearchCriteriaValidator: HotelsSearchCriteriaValidator {
	private let calendar: Calendar
	private let currentDate: @Sendable () -> Date

	public init(
		calendar: Calendar,
		currentDate: @Sendable @escaping () -> Date
	) {
		self.calendar = calendar
		self.currentDate = currentDate
	}

	public func validate(_ criteria: HotelsSearchCriteria) -> HotelsSearchCriteria {
		let (checkIn, checkOut) = validate(
			checkIn: criteria.checkInDate,
			checkOut: criteria.checkOutDate,
			currentDate: currentDate,
			calendar: calendar
		)

		let adults = validate(
			adults: criteria.adults,
			minValue: HotelsSearchLimits.minAdults,
			maxValue: HotelsSearchLimits.maxAdults
		)
		let childrenAge = validate(
			childrenAge: criteria.childrenAge,
			minValue: HotelsSearchLimits.minChildAge,
			maxValue: HotelsSearchLimits.maxChildAge
		)
		let roomsQuantity = validate(
			roomsQuantity: criteria.roomsQuantity,
			minValue: HotelsSearchLimits.minRooms,
			maxValue: HotelsSearchLimits.maxRooms
		)

		return HotelsSearchCriteria(
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
		var checkOut = checkOut

		if checkIn < minCheckIn {
			checkIn = minCheckIn.adding(days: 1, calendar: calendar)
		}
		if checkOut <= checkIn {
			checkOut = checkIn.adding(days: 1, calendar: calendar)
		}

		return (checkIn, checkOut)
	}

	private func validate(adults: Int, minValue: Int, maxValue: Int) -> Int {
		adults.clamp(minValue: minValue, maxValue: maxValue)
	}

	private func validate(childrenAge: [Int], minValue: Int, maxValue: Int) -> [Int] {
		childrenAge.map {
			$0.clamp(minValue: minValue, maxValue: maxValue)
		}
	}

	private func validate(roomsQuantity: Int, minValue: Int, maxValue: Int) -> Int {
		roomsQuantity.clamp(minValue: minValue, maxValue: maxValue)
	}
}
