//
//  HotelsSearchCriteriaComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public protocol HotelsSearchCriteriaFactory {
	func makeSearchCriteria(
		delegate: HotelsSearchCriteriaDelegate,
		provider: HotelsSearchCriteriaProvider,
		cache: HotelsSearchCriteriaCache,
		calendar: Calendar
	) -> UIViewController
}

public final class HotelsSearchCriteriaComposer: HotelsSearchCriteriaFactory {
	public func makeSearchCriteria(
		delegate: HotelsSearchCriteriaDelegate,
		provider: HotelsSearchCriteriaProvider,
		cache: HotelsSearchCriteriaCache,
		calendar: Calendar
	) -> UIViewController {
		let viewController = HotelsSearchCriteriaViewController()
		let interactor = HotelsSearchCriteriaInteractor(
			provider: provider,
			cache: cache
		)
		let presenter = HotelsSearchCriteriaPresenter(calendar: calendar)
		let router = HotelsSearchCriteriaRouter(
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
