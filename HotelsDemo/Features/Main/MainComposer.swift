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

@MainActor
public final class MainComposer: MainFactory {
	private let client: HTTPClient
	private let makeSearchCriteria: @MainActor (HotelsSearchCriteriaDelegate) -> UIViewController

	public init(
		client: HTTPClient,
		searchCriteriaFactory: @escaping @MainActor (HotelsSearchCriteriaDelegate) -> UIViewController
	) {
		self.client = client
		self.makeSearchCriteria = searchCriteriaFactory
	}

	public func makeMain() -> UIViewController {
		let viewControllerProxy = WeakRefVirtualProxy<MainViewController>()
		let searchCriteriaViewController = makeSearchCriteria(viewControllerProxy)

		let presenter = MainPresenter(
			viewController: viewControllerProxy
		)

		let interactor = MainInteractor(presenter: presenter)

		let router = MainRouter(
			searchFactory: HotelsSearchComposer(client: client),
			scene: viewControllerProxy
		)

		let viewController = MainViewController(
			searchCriteriaViewController: searchCriteriaViewController,
			interactor: interactor,
			router: router
		)

		viewControllerProxy.object = viewController
		return viewController
	}
}
