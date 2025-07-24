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
		selectedReviewScore: ReviewScore?
	) -> HotelsFilterPickerModels.FilterViewModel {
		let options = ReviewScore.allCases
			.map { reviewScore in
				HotelsFilterPickerModels.FilterOptionViewModel(
					title: "\(reviewScore.title): \(reviewScore.rawValue)+",
					value: reviewScore,
					isSelected: reviewScore == selectedReviewScore
				)
			}

		return .reviewScore(options: options)
	}
}

public enum ReviewScore: Decimal, CaseIterable {
	case fair = 5.0
	case pleasant = 6.0
	case good = 7.0
	case veryGood = 8.0
	case wonderful = 9.0
}

extension ReviewScore {
	var title: String {
		switch self {
		case .fair:
			return "Fair"
		case .pleasant:
			return "Pleasant"
		case .good:
			return "Good"
		case .veryGood:
			return "Very good"
		case .wonderful:
			return "Wonderful"
		}
	}
}
