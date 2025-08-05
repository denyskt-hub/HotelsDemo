//
//  HotelFilters.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public struct HotelFilters: Equatable {
	public var priceRange: ClosedRange<Decimal>?
	public var starRatings: Set<StarRating>
	public var reviewScore: ReviewScore?

	public init(
		priceRange: ClosedRange<Decimal>? = nil,
		starRatings: Set<StarRating> = [],
		reviewScore: ReviewScore? = nil
	) {
		self.priceRange = priceRange
		self.starRatings = starRatings
		self.reviewScore = reviewScore
	}
}

extension HotelFilters {
	var hasSelectedFilters: Bool {
		!starRatings.isEmpty ||
		priceRange != nil ||
		reviewScore != nil
	}
}
