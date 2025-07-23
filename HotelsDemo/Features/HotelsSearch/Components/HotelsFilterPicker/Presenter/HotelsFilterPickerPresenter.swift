//
//  HotelsFilterPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public final class HotelsFilterPickerPresenter: HotelsFilterPickerPresentationLogic {
	public var viewController: HotelsFilterPickerDisplayLogic?

	public func presentLoad(response: HotelsFilterPickerModels.Load.Response) {
		let viewModel = HotelsFilterPickerModels.Load.ViewModel(
			filters: [
				makePriceRangeFilterViewModel(selectedPriceRange: response.filter.priceRange),
				makeStarRatingFilterViewModel(selectedRatings: response.filter.starRatings),
				makeReviewScoreFilterViewModel(selectedReviewScore: response.filter.minReviewScore)
			]
		)
		viewController?.displayLoad(viewModel: viewModel)
	}

	public func presentSelectedFilter(response: HotelsFilterPickerModels.Select.Response) {
		let viewModel = HotelsFilterPickerModels.Select.ViewModel(
			filter: response.filter
		)
		viewController?.displaySelectedFilter(viewModel: viewModel)
	}

	private func makePriceRangeFilterViewModel(
		selectedPriceRange: ClosedRange<Decimal>?
	) -> HotelsFilterPickerModels.FilterViewModel {
		.priceRange(
			option: .init(
				minPrice: 0,
				maxPrice: 5000,
				currencyCode: "USD",
				selectedRange: selectedPriceRange
			)
		)
	}

	private func makeStarRatingFilterViewModel(
		selectedRatings: Set<Int>?
	) -> HotelsFilterPickerModels.FilterViewModel {
		let options = Array(1...5).map { value in
			HotelsFilterPickerModels.FilterOptionViewModel(
				title: "\(value)",
				value: value,
				isSelected: selectedRatings?.contains(value) ?? false
			)
		}

		return .starRating(options: options)
	}

	private func makeReviewScoreFilterViewModel(
		selectedReviewScore: Decimal?
	) -> HotelsFilterPickerModels.FilterViewModel {
		let options = Array(5...9)
			.map { Decimal($0) }
			.map { value in
				HotelsFilterPickerModels.FilterOptionViewModel(
					title: "\(value)",
					value: value,
					isSelected: value == selectedReviewScore
				)
			}

		return .reviewScore(options: options)
	}
}
