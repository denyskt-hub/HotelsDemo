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
		let delegateProxy = WeakRefVirtualProxy<HotelFiltersPickerViewController>()
		let viewController = HotelFiltersPickerViewController(
			filterViewControllers: makeFilterViewControllers(
				filters: filters,
				delegate: delegateProxy
			)
		)
		let interactor = HotelFiltersPickerInteractor(
			currentFilters: filters
		)
		let presenter = HotelFiltersPickerPresenter()

		viewController.interactor = interactor
		viewController.delegate = delegate
		interactor.presenter = presenter
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
		let viewController = PriceRangeViewController(
			delegate: delegate
		)
		let interactor = PriceRangeInteractor(
			selectedPriceRange: selectedPriceRange,
			currencyCode: currencyCode
		)
		let presenter = PriceRangePresenter()

		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController

		return viewController
	}

	private func makeStarRatingViewController(
		selectedStarRating: Set<StarRating>,
		delegate: StarRatingDelegate
	) -> ResetableFilterViewController {
		let viewController = StarRatingViewController(
			delegate: delegate
		)
		let interactor = StarRatingInteractor(
			selectedStarRatings: selectedStarRating
		)
		let presenter = StarRatingPresenter()

		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController

		return viewController
	}

	private func makeReviewScoreViewController(
		selectedReviewScore: ReviewScore?,
		delegate: ReviewScoreDelegate
	) -> ResetableFilterViewController {
		let viewController = ReviewScoreViewController(
			delegate: delegate
		)
		let interactor = ReviewScoreInteractor(
			selectedReviewScore: selectedReviewScore
		)
		let presenter = ReviewScorePresenter()

		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController

		return viewController
	}
}
