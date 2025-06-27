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
		window?.rootViewController = makeSearchCriteriaViewController()
		window?.makeKeyAndVisible()
	}

	private func makeSearchCriteriaViewController() -> SearchCriteriaViewController {
		let viewController = SearchCriteriaViewController()
		let interactor = SearchCriteriaInteractor(
			provider: searchCriteriaStore.fallback(to: defaultSearchCriteriaProvider),
			cache: searchCriteriaStore
		)
		let presenter = SearchCriteriaPresenter(calendar: calendar)
		let router = SearchCriteriaRouter(calendar: calendar)

		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController

		return viewController
	}
}
