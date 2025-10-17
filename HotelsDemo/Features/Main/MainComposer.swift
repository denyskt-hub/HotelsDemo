//
//  MainComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

public protocol MainFactory {
	func makeMain() -> UIViewController
}

public final class MainComposer: MainFactory {
	private let client: HTTPClient
	private let makeSearchCriteria: (HotelsSearchCriteriaDelegate) -> UIViewController

	public init(
		client: HTTPClient,
		searchCriteriaFactory: @escaping (HotelsSearchCriteriaDelegate) -> UIViewController
	) {
		self.client = client
		self.makeSearchCriteria = searchCriteriaFactory
	}

	public func makeMain() -> UIViewController {
		let delegateProxy = WeakRefVirtualProxy<MainViewController>()
		let searchCriteriaViewController = makeSearchCriteria(delegateProxy)
		let presenter = MainPresenter()
		let interactor = MainInteractor(presenter: presenter)
		let router = MainRouter(
			searchFactory: HotelsSearchComposer(client: client)
		)
		let viewController = MainViewController(
			searchCriteriaViewController: searchCriteriaViewController,
			interactor: interactor,
			router: router
		)

		presenter.viewController = viewController
		router.viewController = viewController

		delegateProxy.object = viewController
		return viewController
	}
}
