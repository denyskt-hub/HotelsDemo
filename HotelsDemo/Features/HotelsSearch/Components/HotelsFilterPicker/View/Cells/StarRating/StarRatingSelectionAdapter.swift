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
	private var selectedStarRatings = Set<StarRating>()

	public var delegate: StarRatingSelectionDelegate?

	public init(selectedStarRatings: Set<StarRating>) {
		self.selectedStarRatings = selectedStarRatings
	}

	public func starRatingSelection(_ starRating: StarRating) {
		if selectedStarRatings.contains(starRating) {
			selectedStarRatings.remove(starRating)
		} else {
			selectedStarRatings.insert(starRating)
		}
		delegate?.didSelectStarRatings(selectedStarRatings)
	}
}
