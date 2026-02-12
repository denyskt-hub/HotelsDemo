//
//  TestAppDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12.02.2026.
//

import UIKit

final class TestAppDelegate: UIResponder, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		let config = UISceneConfiguration(
			name: "Default Configuration",
			sessionRole: connectingSceneSession.role
		)

		config.delegateClass = TestSceneDelegate.self
		return config
	}
}
