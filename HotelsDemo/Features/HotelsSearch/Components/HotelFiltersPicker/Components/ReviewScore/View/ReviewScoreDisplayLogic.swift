//
//  ReviewScoreDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol ReviewScoreDisplayLogic: AnyObject {
	func display(viewModel: ReviewScoreModels.FetchReviewScore.ViewModel)
	func displayReset(viewModel: ReviewScoreModels.ReviewScoreReset.ViewModel)
	func displaySelect(viewModel: ReviewScoreModels.ReviewScoreSelection.ViewModel)
}
