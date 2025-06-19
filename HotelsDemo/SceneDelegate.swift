//
//  SceneDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
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
		let interactor = SearchCriteriaInteractor()
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
