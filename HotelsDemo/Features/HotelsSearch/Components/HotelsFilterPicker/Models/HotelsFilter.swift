//
//  HotelsFilter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public struct HotelsFilter: Equatable {
	public var priceRange: ClosedRange<Decimal>?
	public var starRatings: Set<StarRating>
	public let minReviewScore: ReviewScore?

	public init(
		priceRange: ClosedRange<Decimal>? = nil,
		starRatings: Set<StarRating> = [],
		minReviewScore: ReviewScore? = nil
	) {
		self.priceRange = priceRange
		self.starRatings = starRatings
		self.minReviewScore = minReviewScore
	}
}
