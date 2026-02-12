//
//  TestSceneDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12.02.2026.
//

import UIKit

class TestSceneDelegate: UIResponder, UIWindowSceneDelegate {
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
		window?.rootViewController = UIViewController()
		window?.makeKeyAndVisible()
	}
}
