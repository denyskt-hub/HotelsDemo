//
//  ReviewScorePresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public final class ReviewScorePresenter: ReviewScorePresentationLogic {
	public weak var viewController: ReviewScoreDisplayLogic?

	public init() {
		// Required for initialization in tests
	}

	public func present(response: ReviewScoreModels.FetchReviewScore.Response) {
		let viewModel = ReviewScoreModels.FetchReviewScore.ViewModel(
			options: makeOptionViewModels(response.options)
		)
		viewController?.display(viewModel: viewModel)
	}

	public func presentReset(response: ReviewScoreModels.ReviewScoreReset.Response) {
		let viewModel = ReviewScoreModels.ReviewScoreReset.ViewModel(
			options: makeOptionViewModels(response.options)
		)
		viewController?.displayReset(viewModel: viewModel)
	}

	public func presentSelect(response: ReviewScoreModels.ReviewScoreSelection.Response) {
		let viewModel = ReviewScoreModels.ReviewScoreSelection.ViewModel(
			reviewScore: response.reviewScore,
			options: makeOptionViewModels(response.options)
		)
		viewController?.displaySelect(viewModel: viewModel)
	}

	private func makeOptionViewModels(_ options: [ReviewScoreModels.Option]) -> [ReviewScoreModels.OptionViewModel] {
		options.map {
			.init(title: $0.value.title, value: $0.value, isSelected: $0.isSelected)
		}
	}
}
