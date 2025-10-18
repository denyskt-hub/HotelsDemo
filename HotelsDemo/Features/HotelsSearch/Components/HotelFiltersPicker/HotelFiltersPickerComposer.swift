//
//  HotelFiltersPickerComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import UIKit

public protocol HotelFiltersPickerFactory {
	func makeHotelFiltersPicker(filters: HotelFilters, delegate: HotelFiltersPickerDelegate?) -> UIViewController
}

public final class HotelFiltersPickerComposer: HotelFiltersPickerFactory {
	public func makeHotelFiltersPicker(
		filters: HotelFilters,
		delegate: HotelFiltersPickerDelegate?
	) -> UIViewController {
		let presenter = HotelFiltersPickerPresenter()
		let interactor = HotelFiltersPickerInteractor(
			currentFilters: filters,
			presenter: presenter
		)
		let delegateProxy = WeakRefVirtualProxy<HotelFiltersPickerViewController>()
		let viewController = HotelFiltersPickerViewController(
			filterViewControllers: makeFilterViewControllers(
				filters: filters,
				delegate: delegateProxy
			),
			interactor: interactor,
			delegate: delegate
		)

		presenter.viewController = viewController

		delegateProxy.object = viewController
		return viewController
	}

	private func makeFilterViewControllers(
		filters: HotelFilters,
		delegate: HotelFiltersScene
	) -> [ResetableFilterViewController] {
		[
			makePriceRangeViewController(
				selectedPriceRange: filters.priceRange,
				currencyCode: CurrencyCode.usd.rawValue,
				delegate: delegate
			),
			makeStarRatingViewController(
				selectedStarRating: filters.starRatings,
				delegate: delegate
			),
			makeReviewScoreViewController(
				selectedReviewScore: filters.reviewScore,
				delegate: delegate
			)
		]
	}

	private func makePriceRangeViewController(
		selectedPriceRange: ClosedRange<Decimal>?,
		currencyCode: String,
		delegate: PriceRangeDelegate
	) -> ResetableFilterViewController {
		let presenter = PriceRangePresenter()
		let interactor = PriceRangeInteractor(
			selectedPriceRange: selectedPriceRange,
			currencyCode: currencyCode,
			presenter: presenter
		)
		let viewController = PriceRangeViewController(
			interactor: interactor,
			delegate: delegate
		)

		presenter.viewController = viewController

		return viewController
	}

	private func makeStarRatingViewController(
		selectedStarRating: Set<StarRating>,
		delegate: StarRatingDelegate
	) -> ResetableFilterViewController {
		let presenter = StarRatingPresenter()
		let interactor = StarRatingInteractor(
			selectedStarRatings: selectedStarRating,
			presenter: presenter
		)
		let viewController = StarRatingViewController(
			interactor: interactor,
			delegate: delegate
		)

		presenter.viewController = viewController

		return viewController
	}

	private func makeReviewScoreViewController(
		selectedReviewScore: ReviewScore?,
		delegate: ReviewScoreDelegate
	) -> ResetableFilterViewController {
		let presenter = ReviewScorePresenter()
		let interactor = ReviewScoreInteractor(
			selectedReviewScore: selectedReviewScore,
			presenter: presenter
		)
		let viewController = ReviewScoreViewController(
			interactor: interactor,
			delegate: delegate
		)

		presenter.viewController = viewController

		return viewController
	}
}
