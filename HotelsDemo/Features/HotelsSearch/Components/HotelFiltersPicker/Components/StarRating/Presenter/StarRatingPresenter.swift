//
//  StarRatingPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public final class StarRatingPresenter: StarRatingPresentationLogic {
	public weak var viewController: StarRatingDisplayLogic?

	public init() {
		// Required for initialization in tests
	}

	public func present(response: StarRatingModels.Load.Response) {
		let viewModel = StarRatingModels.Load.ViewModel(
			options: makeOptionViewModels(response.options)
		)
		viewController?.display(viewModel: viewModel)
	}

	public func presentReset(response: StarRatingModels.Reset.Response) {
		let viewModel = StarRatingModels.Reset.ViewModel(
			options: makeOptionViewModels(response.options)
		)
		viewController?.displayReset(viewModel: viewModel)
	}

	public func presentSelect(response: StarRatingModels.Select.Response) {
		let viewModel = StarRatingModels.Select.ViewModel(
			starRatings: response.starRatings,
			options: makeOptionViewModels(response.options)
		)
		viewController?.displaySelect(viewModel: viewModel)
	}

	private func makeOptionViewModels(_ options: [StarRatingModels.Option]) -> [StarRatingModels.OptionViewModel] {
		options.map {
			.init(title: $0.value.title, value: $0.value, isSelected: $0.isSelected)
		}
	}
}
