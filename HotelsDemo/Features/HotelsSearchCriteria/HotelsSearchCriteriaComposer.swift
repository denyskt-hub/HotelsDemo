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

@MainActor
public final class HotelsSearchCriteriaComposer: HotelsSearchCriteriaFactory {
	private let client: HTTPClient
	private let baseURL: URL

	public init(
		client: HTTPClient,
		baseURL: URL
	) {
		self.client = client
		self.baseURL = baseURL
	}

	public func makeSearchCriteria(
		delegate: HotelsSearchCriteriaDelegate,
		provider: HotelsSearchCriteriaProvider,
		cache: HotelsSearchCriteriaCache,
		calendar: Calendar
	) -> UIViewController {
		let viewControllerProxy = WeakRefVirtualProxy<HotelsSearchCriteriaViewController>()

		let presenter = HotelsSearchCriteriaPresenter(
			calendar: calendar,
			viewController: viewControllerProxy
		)

		let interactor = HotelsSearchCriteriaInteractor(
			cache: cache,
			provider: provider,
			presenter: presenter
		)

		let router = HotelsSearchCriteriaRouter(
			calendar: calendar,
			destinationPickerFactory: DestinationPickerComposer(client: client, baseURL: baseURL),
			dateRangePickerFactory: DateRangePickerComposer(),
			roomGuestsPickerFactory: RoomGuestsPickerComposer(),
			scene: viewControllerProxy
		)

		let viewController = HotelsSearchCriteriaViewController(
			interactor: interactor,
			router: router,
			delegate: delegate
		)

		viewControllerProxy.object = viewController
		return viewController
	}
}
