//
//  AppDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		configureLogging()
		return true
	}

	private func configureLogging() {
		Logger.configuration = .init(
			level: .debug,
			enabledTags: [.general, .networking, .custom("cache")]
		)

		SharedImageDataCache.configureLogging(enabled: false)
		SharedImageDataLoader.configureLogging(enabled: true)
		SharedImageDataPrefetcher.configureLogging(enabled: true)
	}
}
