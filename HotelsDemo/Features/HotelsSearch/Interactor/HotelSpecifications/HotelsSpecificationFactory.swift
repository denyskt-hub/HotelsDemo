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

public struct AlwaysTrueHotelSpecification: HotelSpecification {
	public func isSatisfied(by hotel: Hotel) -> Bool { true }
}

public struct AnySpecification<T>: Specification {
	private let _isSatisfied: (T) -> Bool

	public init<S: Specification>(_ spec: S) where S.Item == T {
		self._isSatisfied = spec.isSatisfied(by:)
	}

	public func isSatisfied(by item: T) -> Bool {
		_isSatisfied(item)
	}

	public func and(_ other: AnySpecification<T>) -> AnySpecification<T> {
		AnySpecification(AndSpecification(lhs: self, rhs: other))
	}

	public func or(_ other: AnySpecification<T>) -> AnySpecification<T> {
		AnySpecification(OrSpecification(lhs: self, rhs: other))
	}
}

extension AnySpecification: HotelSpecification where Item == Hotel {}
