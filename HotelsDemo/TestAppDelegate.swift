//
//  TestAppDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12.02.2026.
//

import UIKit

final class TestAppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
	}
}
