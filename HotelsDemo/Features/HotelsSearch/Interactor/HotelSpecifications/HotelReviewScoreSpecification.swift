//
//  HotelReviewScoreSpecification.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import Foundation

public struct HotelReviewScoreSpecification: HotelSpecification {
	private let minReviewScore: Decimal

	public init(reviewScores: [Decimal]) {
		self.minReviewScore = reviewScores.min() ?? 0
	}

	public func isSatisfied(by item: Hotel) -> Bool {
		return item.reviewScore >= minReviewScore
	}
}
