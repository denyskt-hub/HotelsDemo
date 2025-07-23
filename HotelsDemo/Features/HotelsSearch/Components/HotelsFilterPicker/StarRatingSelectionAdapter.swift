//
//  StarRatingSelectionAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import Foundation

public protocol StarRatingSelectionDelegate: AnyObject {
	func didSelectStarRatings(_ starRatings: Set<Int>)
}

public final class StarRatingSelectionAdapter: StarRatingCellControllerDelegate {
	private var starRatings = Set<Int>()

	public var delegate: StarRatingSelectionDelegate?

	public init(starRatings: Set<Int>) {
		self.starRatings = starRatings
	}

	public func starRatingSelection(_ starRating: Int) {
		if starRatings.contains(starRating) {
			starRatings.remove(starRating)
		} else {
			starRatings.insert(starRating)
		}
		delegate?.didSelectStarRatings(starRatings)
	}
}
