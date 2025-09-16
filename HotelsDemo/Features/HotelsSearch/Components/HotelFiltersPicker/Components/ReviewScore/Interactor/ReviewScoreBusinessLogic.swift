//
//  ReviewScoreBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol ReviewScoreBusinessLogic {
	func doFetchReviewScore(request: ReviewScoreModels.FetchReviewScore.Request)
	func handleReviewScoreReset(request: ReviewScoreModels.ReviewScoreReset.Request)
	func handleReviewScoreSelection(request: ReviewScoreModels.ReviewScoreSelection.Request)
}
