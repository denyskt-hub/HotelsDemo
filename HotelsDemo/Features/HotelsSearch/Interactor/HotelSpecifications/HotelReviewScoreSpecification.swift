//
//  HotelReviewScoreSpecification.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import Foundation

public struct HotelReviewScoreSpecification: HotelSpecification {
	private let minReviewScore: Decimal

	public init(minReviewScore: Decimal) {
		self.minReviewScore = minReviewScore
	}

	public func isSatisfied(by item: Hotel) -> Bool {
		item.reviewScore >= minReviewScore
	}
}
