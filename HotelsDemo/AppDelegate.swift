//
//  AppDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		configureLogging()
		return true
	}

	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		let config = UISceneConfiguration(
			name: "Default Configuration",
			sessionRole: connectingSceneSession.role
		)

		config.delegateClass = SceneDelegate.self
		return config
	}

	private func configureLogging() {
		Logger.configure(
			.init(
				level: .debug,
				enabledTags: [.general, .networking]
			)
		)

		SharedImageDataCache.configureLogging(enabled: false)
		SharedImageDataLoader.configureLogging(enabled: false)
		SharedImageDataPrefetcher.configureLogging(enabled: false)
	}
}
