//
//  DefaultHotelsSearchCriteriaProvider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DefaultHotelsSearchCriteriaProvider: HotelsSearchCriteriaProvider {
	private let calendar: Calendar
	private let currentDate: @Sendable () -> Date

	public init(
		calendar: Calendar,
		currentDate: @Sendable @escaping () -> Date
	) {
		self.calendar = calendar
		self.currentDate = currentDate
	}

	public func retrieve() async throws -> HotelsSearchCriteria {
		HotelsSearchCriteriaDefaults.make(calendar: calendar, currentDate: currentDate)
	}
}
