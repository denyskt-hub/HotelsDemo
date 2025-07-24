//
//  ReviewScoreSelectionAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/7/25.
//

import Foundation

public protocol ReviewScoreSelectionDelegate: AnyObject {
	func didSelectReviewScores(_ reviewScores: Set<ReviewScore>)
}

public final class ReviewScoreSelectionAdapter: ReviewScoreCellControllerDelegate {
	private var selectedReivewScores = Set<ReviewScore>()

	public var delegate: ReviewScoreSelectionDelegate?

	public init(selectedReivewScores: Set<ReviewScore>) {
		self.selectedReivewScores = selectedReivewScores
	}

	public func reviewScoreSelection(_ reviewScore: ReviewScore) {
		if selectedReivewScores.contains(reviewScore) {
			selectedReivewScores.remove(reviewScore)
		} else {
			selectedReivewScores.insert(reviewScore)
		}
		delegate?.didSelectReviewScores(selectedReivewScores)
	}
}
