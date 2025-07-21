//
//  HotelStarRatingSpecification.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import Foundation

public struct HotelStarRatingSpecification: HotelSpecification {
	private let allowedRatings: Set<Int>

	public init(allowedRatings: Set<Int>) {
		self.allowedRatings = allowedRatings
	}

	public func isSatisfied(by item: Hotel) -> Bool {
		allowedRatings.contains(item.starRating)
	}
}
