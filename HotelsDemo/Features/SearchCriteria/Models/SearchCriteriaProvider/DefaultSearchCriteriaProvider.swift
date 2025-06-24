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

		completion(
			.success(
				SearchCriteria(
					destination: nil,
					checkInDate: today.adding(days: 1),
					checkOutDate: today.adding(days: 2),
					adults: 2,
					childrenAge: [],
					roomsQuantity: 1
				)
			)
		)
	}
}
