//
//  HotelsSpecificationFactory.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import Foundation

public enum HotelsSpecificationFactory {
	public static func make(from filters: HotelFilters) -> any HotelSpecification {
		var spec = AnySpecification(AlwaysTrueHotelSpecification())

		if let priceRange = filters.priceRange {
			spec = spec.and(AnySpecification(HotelPriceSpecification(priceRange: priceRange)))
		}

		if !filters.starRatings.isEmpty {
			spec = spec.and(AnySpecification(HotelStarRatingSpecification(allowedRatings: filters.starRatings.map(\.rawValue))))
		}

		if let reviewScore = filters.reviewScore {
			spec = spec.and(AnySpecification(HotelReviewScoreSpecification(reviewScore: reviewScore.rawValue)))
		}

		return spec
	}
}

extension AnySpecification: HotelSpecification where Item == Hotel {}
