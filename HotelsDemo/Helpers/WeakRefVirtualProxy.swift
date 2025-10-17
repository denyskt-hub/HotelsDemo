//
//  WeakRefVirtualProxy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class WeakRefVirtualProxy<T: AnyObject> {
	public weak var object: T?

	public init(object: T? = nil) {
		self.object = object
	}
}

extension WeakRefVirtualProxy: HotelsSearchCriteriaDelegate where T: HotelsSearchCriteriaDelegate {
	public func didRequestSearch(with searchCriteria: HotelsSearchCriteria) {
		object?.didRequestSearch(with: searchCriteria)
	}
}

extension WeakRefVirtualProxy: DateRangePickerDelegate where T: DateRangePickerDelegate {
	public func didSelectDateRange(startDate: Date, endDate: Date) {
		object?.didSelectDateRange(startDate: startDate, endDate: endDate)
	}
}

extension WeakRefVirtualProxy: HotelFiltersScene where T: HotelFiltersScene {}

extension WeakRefVirtualProxy: PriceRangeDelegate where T: PriceRangeDelegate {
	public func didSelectPriceRange(_ priceRange: ClosedRange<Decimal>?) {
		object?.didSelectPriceRange(priceRange)
	}
}

extension WeakRefVirtualProxy: StarRatingDelegate where T: StarRatingDelegate {
	public func didSelectStarRatings(_ starRatings: Set<StarRating>) {
		object?.didSelectStarRatings(starRatings)
	}
}

extension WeakRefVirtualProxy: ReviewScoreDelegate where T: ReviewScoreDelegate {
	public func didSelectReviewScore(_ reviewScore: ReviewScore?) {
		object?.didSelectReviewScore(reviewScore)
	}
}
