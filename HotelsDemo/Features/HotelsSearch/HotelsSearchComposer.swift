//
//  HotelsSearchComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

public protocol HotelsSearchFactory {
	func makeSearch(with criteria: HotelsSearchCriteria) -> UIViewController
}

public final class HotelsSearchComposer: HotelsSearchFactory {
	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	public func makeSearch(with criteria: HotelsSearchCriteria) -> UIViewController {
		let context = makeHotelsSearchContext(with: criteria)
		let presenter = HotelsSearchPresenter(
			priceFormatter: PriceFormatter()
		)
		let interactor = HotelsSearchInteractor(
			context: context,
			filters: HotelFilters(),
			repository: DefaultHotelsRepository(),
			presenter: presenter
		)
		let router = HotelsSearchRouter(
			hotelFiltersPickerFactory: HotelFiltersPickerComposer()
		)
		let viewController = HotelsSearchViewController(
			interactor: interactor,
			router: router
		)
		let viewControllerAdapter = HotelsSearchDisplayLogicAdapter(
			viewController: viewController
		)

		presenter.viewController = viewControllerAdapter
		router.viewController = viewController

		return viewController
	}

	private func makeHotelsSearchContext(with criteria: HotelsSearchCriteria) -> HotelsSearchContext {
		let provider = InMemoryHotelsSearchCriteriaStore(
			criteria: criteria
		).dispatch(to: MainQueueDispatcher())

		let service = HotelsSearchWorker(
			factory: DefaultHotelsRequestFactory(
				url: HotelsEndpoint.searchHotels.url(Environment.baseURL)
			),
			client: client
		).dispatch(to: MainQueueDispatcher())

		return HotelsSearchContext(
			provider: provider,
			service: service
		)
	}
}
