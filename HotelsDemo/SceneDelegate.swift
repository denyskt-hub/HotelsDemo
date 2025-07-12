//
//  SceneDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	private lazy var calendar: Calendar = {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		return calendar
	}()

	private lazy var storeURL: URL = {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		return documentsURL.appendingPathComponent("search-criteria.store")
	}()

	private lazy var searchCriteriaStore: SearchCriteriaStore = {
		ValidatingSearchCriteriaStore(
			decoratee: CodableSearchCriteriaStore(
				storeURL: storeURL,
				dispatcher: MainQueueDispatcher()
			),
			validator: DefaultSearchCriteriaValidator(
				calendar: calendar,
				currentDate: Date.init
			)
		)
	}()

	private lazy var defaultSearchCriteriaProvider: SearchCriteriaProvider = {
		DefaultSearchCriteriaProvider(
			calendar: calendar,
			currentDate: Date.init
		)
	}()

	private var searchCriteriaFactory: SearchCriteriaFactory {
		SearchCriteriaComposer()
	}

	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: scene)
		configureWindow()
	}

	func configureWindow() {
		window?.rootViewController = makeMainViewController().embeddedInNavigationController()
		window?.makeKeyAndVisible()
	}

	private func makeMainViewController() -> UIViewController {
		let delegateProxy = WeakRefVirtualProxy<MainViewController>()
		let searchCriteriaViewController = makeSearchCriteriaViewController(
			delegate: delegateProxy
		)
		let viewController = MainViewController(
			searchCriteriaViewController: searchCriteriaViewController
		)
		let interactor = MainInteractor()
		let presenter = MainPresenter()
		let router = MainRouter()

		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController

		delegateProxy.object = viewController
		return viewController
	}

	private func makeSearchCriteriaViewController(delegate: SearchCriteriaDelegate) -> UIViewController {
		searchCriteriaFactory.makeSearchCriteria(
			delegate: delegate,
			provider: searchCriteriaStore.fallback(to: defaultSearchCriteriaProvider),
			cache: searchCriteriaStore,
			calendar: calendar
		)
	}
}
