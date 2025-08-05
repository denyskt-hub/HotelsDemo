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
	private let imageDataCache: ImageDataCache

	public init(
		client: HTTPClient,
		imageDataCache: ImageDataCache
	) {
		self.client = client
		self.imageDataCache = imageDataCache
	}

	public func makeSearch(with criteria: HotelsSearchCriteria) -> UIViewController {
		let viewController = HotelsSearchViewController()
		let viewControllerAdapter = HotelsSearchDisplayLogicAdapter(
			viewController: viewController
		)
		let interactor = HotelsSearchInteractor(
			criteria: criteria,
			filters: HotelFilters(),
			repository: DefaultHotelsRepository(),
			worker: HotelsSearchWorker(
				factory: DefaultHotelsRequestFactory(
					url: HotelsEndpoint.searchHotels.url(Environment.baseURL)
				),
				client: client,
				dispatcher: MainQueueDispatcher()
			)
		)
		let presenter = HotelsSearchPresenter(
			priceFormatter: PriceFormatter()
		)
		let router = HotelsSearchRouter(
			hotelFiltersPickerFactory: HotelFiltersPickerComposer()
		)

		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewControllerAdapter
		router.viewController = viewController

		return viewController
	}
}
