//
//  WeakRefVirtualProxy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
	weak var object: T?

	init(object: T? = nil) {
		self.object = object
	}
}

extension WeakRefVirtualProxy: HotelsSearchCriteriaDelegate where T: HotelsSearchCriteriaDelegate {
	func didRequestSearch(with searchCriteria: HotelsSearchCriteria) {
		object?.didRequestSearch(with: searchCriteria)
	}
}

extension WeakRefVirtualProxy: ReviewScoreDelegate where T: ReviewScoreDelegate {
	func didSelectReviewScore(_ reviewScore: ReviewScore?) {
		object?.didSelectReviewScore(reviewScore)
	}
}
