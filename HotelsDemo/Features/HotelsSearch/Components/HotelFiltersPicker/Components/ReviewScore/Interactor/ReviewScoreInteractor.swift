//
//  ReviewScoreInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public final class ReviewScoreInteractor: ReviewScoreBusinessLogic {
	private var selectedReviewScore: ReviewScore?

	public var presenter: ReviewScorePresentationLogic?

	public init(selectedReviewScore: ReviewScore?) {
		self.selectedReviewScore = selectedReviewScore
	}

	public func load(request: ReviewScoreModels.Load.Request) {
		presenter?.present(response: .init(options: makeOptions(selectedReviewScore)))
	}

	public func reset(request: ReviewScoreModels.Reset.Request) {
		selectedReviewScore = nil
		presenter?.presentReset(response: .init(options: makeOptions(selectedReviewScore)))
	}

	public func select(request: ReviewScoreModels.Select.Request) {
		selectedReviewScore = selectedReviewScore != request.reviewScore ? request.reviewScore : nil
		presenter?.presentSelect(
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
