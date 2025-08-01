//
//  HotelReviewScoreSpecification.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import Foundation

public struct HotelReviewScoreSpecification: HotelSpecification {
	private let minReviewScore: Decimal

	public init(reviewScore: Decimal) {
		self.minReviewScore = reviewScore
	}

	public func isSatisfied(by item: Hotel) -> Bool {
		return item.reviewScore >= minReviewScore
	}
}
