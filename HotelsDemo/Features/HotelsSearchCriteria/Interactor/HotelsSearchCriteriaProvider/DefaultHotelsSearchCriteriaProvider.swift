//
//  DefaultHotelsSearchCriteriaProvider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DefaultHotelsSearchCriteriaProvider: HotelsSearchCriteriaProvider {
	private let calendar: Calendar
	private let currentDate: () -> Date

	public init(
		calendar: Calendar,
		currentDate: @escaping () -> Date
	) {
		self.calendar = calendar
		self.currentDate = currentDate
	}

	public func retrieve(completion: @escaping (HotelsSearchCriteriaProvider.RetrieveResult) -> Void) {
		completion(
			.success(
				HotelsSearchCriteriaDefaults.make(calendar: calendar, currentDate: currentDate)
			)
		)
	}
}
