//
//  SceneDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	lazy var storeURL: URL = {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		return documentsURL.appendingPathComponent("search-criteria.store")
	}()

	lazy var searchCriteriaStore: SearchCriteriaStore = {
		CodableSearchCriteriaStore(
			storeURL: storeURL,
			dispatcher: MainQueueDispatcher()
		)
	}()

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
			provider: searchCriteriaStore,
			cache: searchCriteriaStore
		)
		let presenter = SearchCriteriaPresenter()
		let router = SearchCriteriaRouter()

		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController

		return viewController
	}
}
