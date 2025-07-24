//
//  StarRatingSelectionAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import Foundation

public protocol StarRatingSelectionDelegate: AnyObject {
	func didSelectStarRatings(_ starRatings: Set<StarRating>)
}

public final class StarRatingSelectionAdapter: StarRatingCellControllerDelegate {
	private var starRatings = Set<StarRating>()

	public var delegate: StarRatingSelectionDelegate?

	public init(starRatings: Set<StarRating>) {
		self.starRatings = starRatings
	}

	public func starRatingSelection(_ starRating: StarRating) {
		if starRatings.contains(starRating) {
			starRatings.remove(starRating)
		} else {
			starRatings.insert(starRating)
		}
		delegate?.didSelectStarRatings(starRatings)
	}
}
