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
		completion(
			.success(
				SearchCriteriaDefaults.make(calendar: calendar, currentDate: currentDate)
			)
		)
	}
}
