//
//  DefaultSearchCriteriaProvider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DefaultSearchCriteriaProvider: SearchCriteriaProvider {
	private let calendar: Calendar
	private let currentDate: () -> Date

	public init(
		calendar: Calendar,
		currentDate: @escaping () -> Date
	) {
		self.calendar = calendar
		self.currentDate = currentDate
	}

	public func retrieve(completion: @escaping (SearchCriteriaProvider.RetrieveResult) -> Void) {
		let today = calendar.startOfDay(for: currentDate())
		let minCheckIn = today.adding(days: 1, calendar: calendar)
		let minCheckOut = minCheckIn.adding(days: 1, calendar: calendar)

		completion(
			.success(
				SearchCriteria(
					destination: nil,
					checkInDate: minCheckIn,
					checkOutDate: minCheckOut,
					adults: 2,
					childrenAge: [],
					roomsQuantity: 1
				)
			)
		)
	}
}
