//
//  WeakRefVirtualProxy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit
import Foundation

public final class WeakRefVirtualProxy<T: AnyObject> {
	public weak var object: T?

	public init(object: T? = nil) {
		self.object = object
	}
}

extension WeakRefVirtualProxy: Routable where T: Routable {
	public func present(_ viewController: UIViewController) {
		object?.present(viewController)
	}

	public func show(_ viewController: UIViewController) {
		object?.show(viewController)
	}
}

extension WeakRefVirtualProxy: MainDisplayLogic where T: MainDisplayLogic {
	public func displaySearch(viewModel: MainModels.Search.ViewModel) {
		object?.displaySearch(viewModel: viewModel)
	}
}

extension WeakRefVirtualProxy: HotelsSearchCriteriaDelegate where T: HotelsSearchCriteriaDelegate {
	public func didRequestSearch(with searchCriteria: HotelsSearchCriteria) {
		object?.didRequestSearch(with: searchCriteria)
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
