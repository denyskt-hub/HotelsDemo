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
	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	public func makeSearchCriteria(
		delegate: HotelsSearchCriteriaDelegate,
		provider: HotelsSearchCriteriaProvider,
		cache: HotelsSearchCriteriaCache,
		calendar: Calendar
	) -> UIViewController {
		let presenter = HotelsSearchCriteriaPresenter(calendar: calendar)
		let interactor = HotelsSearchCriteriaInteractor(
			cache: cache,
			provider: provider,
			presenter: presenter
		)
		let router = HotelsSearchCriteriaRouter(
			calendar: calendar,
			destinationPickerFactory: DestinationPickerComposer(client: client),
			dateRangePickerFactory: DateRangePickerComposer(),
			roomGuestsPickerFactory: RoomGuestsPickerComposer()
		)
		let viewController = HotelsSearchCriteriaViewController(
			interactor: interactor,
			router: router,
			delegate: delegate
		)

		presenter.viewController = viewController
		router.viewController = viewController

		return viewController
	}
}
