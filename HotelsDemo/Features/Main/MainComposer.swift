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
	private let makeSearchCriteria: (HotelsSearchCriteriaDelegate) -> UIViewController

	public init(searchCriteriaFactory: @escaping (HotelsSearchCriteriaDelegate) -> UIViewController) {
		self.makeSearchCriteria = searchCriteriaFactory
	}

	public func makeMain() -> UIViewController {
		let delegateProxy = WeakRefVirtualProxy<MainViewController>()
		let searchCriteriaViewController = makeSearchCriteria(delegateProxy)
		let viewController = MainViewController(
			searchCriteriaViewController: searchCriteriaViewController
		)
		let interactor = MainInteractor()
		let presenter = MainPresenter()
		let router = MainRouter(
			searchFactory: HotelsSearchComposer(
				imageDataCache: InMemoryImageDataCache(countLimit: 100)
			)
		)

		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController

		delegateProxy.object = viewController
		return viewController
	}
}
