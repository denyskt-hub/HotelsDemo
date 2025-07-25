//
//  HotelFiltersPickerComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import UIKit

public protocol HotelFiltersPickerFactory {
	func makeHotelFiltersPicker(filter: HotelsFilter, delegate: HotelFiltersPickerDelegate?) -> UIViewController
}

public final class HotelFiltersPickerComposer: HotelFiltersPickerFactory {
	public func makeHotelFiltersPicker(
		filter: HotelsFilter,
		delegate: HotelFiltersPickerDelegate?
	) -> UIViewController {
		let delegateProxy = WeakRefVirtualProxy<HotelFiltersPickerViewController>()
		let viewController = HotelFiltersPickerViewController(
			filterViewControllers: [
				makeReviewScoreViewController(
					selectedReviewScore: filter.reviewScores.first,
					delegate: delegateProxy
				)
			]
		)
		let interactor = HotelFiltersPickerInteractor(
			currentFilter: filter
		)
		let presenter = HotelFiltersPickerPresenter()

		viewController.interactor = interactor
		viewController.delegate = delegate
		interactor.presenter = presenter
		presenter.viewController = viewController

		delegateProxy.object = viewController
		return viewController
	}

	private func makeReviewScoreViewController(
		selectedReviewScore: ReviewScore?,
		delegate: ReviewScoreDelegate?
	) -> ResetableFilterViewController {
		let viewController = ReviewScoreViewController()
		let interactor = ReviewScoreInteractor(
			selectedReviewScore: selectedReviewScore
		)
		let presenter = ReviewScorePresenter()

		viewController.interactor = interactor
		viewController.delegate = delegate
		interactor.presenter = presenter
		presenter.viewController = viewController

		return viewController
	}
}
