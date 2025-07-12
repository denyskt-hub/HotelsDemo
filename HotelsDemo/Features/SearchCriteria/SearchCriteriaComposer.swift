//
//  SearchCriteriaComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public protocol SearchCriteriaFactory {
	func makeSearchCriteria(
		delegate: SearchCriteriaDelegate?,
		provider: SearchCriteriaProvider,
		cache: SearchCriteriaCache,
		calendar: Calendar
	) -> UIViewController
}

public final class SearchCriteriaComposer: SearchCriteriaFactory {
	public func makeSearchCriteria(
		delegate: SearchCriteriaDelegate?,
		provider: SearchCriteriaProvider,
		cache: SearchCriteriaCache,
		calendar: Calendar
	) -> UIViewController {
		let viewController = SearchCriteriaViewController()
		let interactor = SearchCriteriaInteractor(
			provider: provider,
			cache: cache
		)
		let presenter = SearchCriteriaPresenter(calendar: calendar)
		let router = SearchCriteriaRouter(
			calendar: calendar,
			destinationPickerFactory: DestinationPickerComposer(),
			dateRangePickerFactory: DateRangePickerComposer(),
			roomGuestsPickerFactory: RoomGuestsPickerComposer()
		)

		viewController.interactor = interactor
		viewController.router = router
		viewController.delegate = delegate
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController

		return viewController
	}
}
