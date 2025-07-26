//
//  HotelsFilter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public struct HotelsFilter: Equatable {
	public var priceRange: ClosedRange<Decimal>?
	public var starRatings: Set<StarRating>
	public var reviewScores: Set<ReviewScore>

	public init(
		priceRange: ClosedRange<Decimal>? = nil,
		starRatings: Set<StarRating> = [],
		reviewScores: Set<ReviewScore> = []
	) {
		self.priceRange = priceRange
		self.starRatings = starRatings
		self.reviewScores = reviewScores
	}
}
