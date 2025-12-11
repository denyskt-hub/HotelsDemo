//
//  SelectedDateRange.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11.12.2025.
//

import Foundation

public struct SelectedDateRange {
	public let startDate: Date?
	public let endDate: Date?

	public init(startDate: Date?, endDate: Date?) {
		self.startDate = startDate
		self.endDate = endDate
	}
}
