//
//  ReviewScorePresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol ReviewScorePresentationLogic {
	func present(response: ReviewScoreModels.FetchReviewScore.Response)
	func presentReset(response: ReviewScoreModels.ReviewScoreReset.Response)
	func presentSelect(response: ReviewScoreModels.ReviewScoreSelection.Response)
}
