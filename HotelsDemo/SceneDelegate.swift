//
//  SceneDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	/// The composition root must live as long as the app: the dependency
	/// graph it composes references it back through factory closures.
	private var compositionRoot: AppCompositionRoot?

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
		window?.rootViewController = makeRootViewController()
		window?.makeKeyAndVisible()
	}

	/// Boots the app when the environment is configured,
	/// or shows an explanatory error screen when it is not.
	private func makeRootViewController() -> UIViewController {
		do {
			let compositionRoot = try AppCompositionRoot()
			self.compositionRoot = compositionRoot
			return compositionRoot.compose()
		} catch {
			return ConfigurationErrorViewController(message: "\(error)")
		}
	}
}
