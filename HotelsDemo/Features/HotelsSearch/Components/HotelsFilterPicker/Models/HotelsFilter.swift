//
//  HotelsFilter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public struct HotelsFilter: Equatable {
	public var priceRange: ClosedRange<Decimal>?
	public let starRatings: Set<Int>
	public let minReviewScore: Decimal?

	public init(
		priceRange: ClosedRange<Decimal>? = nil,
		starRatings: Set<Int> = [],
		minReviewScore: Decimal? = nil
	) {
		self.priceRange = priceRange
		self.starRatings = starRatings
		self.minReviewScore = minReviewScore
	}
}
