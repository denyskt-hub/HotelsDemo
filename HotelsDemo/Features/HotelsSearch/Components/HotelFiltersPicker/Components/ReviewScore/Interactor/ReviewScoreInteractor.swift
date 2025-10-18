//
//  ReviewScoreInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public final class ReviewScoreInteractor: ReviewScoreBusinessLogic {
	private var selectedReviewScore: ReviewScore?
	private let presenter: ReviewScorePresentationLogic

	public init(
		selectedReviewScore: ReviewScore?,
		presenter: ReviewScorePresentationLogic
	) {
		self.selectedReviewScore = selectedReviewScore
		self.presenter = presenter
	}

	public func doFetchReviewScore(request: ReviewScoreModels.FetchReviewScore.Request) {
		presenter.present(response: .init(options: makeOptions(selectedReviewScore)))
	}

	public func handleReviewScoreReset(request: ReviewScoreModels.ReviewScoreReset.Request) {
		selectedReviewScore = nil
		presenter.presentReset(response: .init(options: makeOptions(selectedReviewScore)))
	}

	public func handleReviewScoreSelection(request: ReviewScoreModels.ReviewScoreSelection.Request) {
		selectedReviewScore = selectedReviewScore != request.reviewScore ? request.reviewScore : nil
		presenter.presentSelect(
			response: .init(
				reviewScore: selectedReviewScore,
				options: makeOptions(selectedReviewScore)
			)
		)
	}

	private func makeOptions(_ selectedReviewScore: ReviewScore?) -> [ReviewScoreModels.Option] {
		ReviewScore.allCases.toOptions(selected: selectedReviewScore)
	}
}
