//
//  SceneDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	private let client: HTTPClient = {
		RapidAPIHTTPClient(
			client: LoggingHTTPClient(
				client: URLSessionHTTPClient()
			)
		)
	}()

	private lazy var calendar: Calendar = {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		return calendar
	}()

	private lazy var storeURL: URL = {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		return documentsURL.appendingPathComponent("search-criteria.store")
	}()

	private lazy var searchCriteriaStore: HotelsSearchCriteriaStore = {
		ValidatingHotelsSearchCriteriaStore(
			decoratee: CodableHotelsSearchCriteriaStore(storeURL: storeURL),
			validator: DefaultHotelsSearchCriteriaValidator(
				calendar: calendar,
				currentDate: Date.init
			)
		).dispatch(to: MainQueueDispatcher())
	}()

	private lazy var defaultSearchCriteriaProvider: HotelsSearchCriteriaProvider = {
		DefaultHotelsSearchCriteriaProvider(
			calendar: calendar,
			currentDate: Date.init
		)
	}()

	private lazy var mainFactory: MainFactory = {
		MainComposer(
			client: client,
			searchCriteriaFactory: makeSearchCriteriaViewController(delegate:)
		)
	}()

	private lazy var searchCriteriaFactory: HotelsSearchCriteriaFactory = {
		HotelsSearchCriteriaComposer(client: client)
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
		window?.rootViewController = makeMainViewController().embeddedInNavigationController()
		window?.makeKeyAndVisible()
	}

	private func makeMainViewController() -> UIViewController {
		mainFactory.makeMain()
	}

	private func makeSearchCriteriaViewController(delegate: HotelsSearchCriteriaDelegate) -> UIViewController {
		searchCriteriaFactory.makeSearchCriteria(
			delegate: delegate,
			provider: searchCriteriaStore.fallback(to: defaultSearchCriteriaProvider),
			cache: searchCriteriaStore,
			calendar: calendar
		)
	}
}
