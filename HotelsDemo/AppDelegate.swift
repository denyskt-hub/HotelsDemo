//
//  AppDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var environment: Environment.Config!

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		configureEnvironment()
		configureLogging()
		return true
	}

	private func configureEnvironment() {
		do {
			environment = try Environment.load()
		} catch {
			fatalError(
				"""
				Environment misconfigured: \(error)
				See README for required environment keys and configuration steps.
				"""
			)
		}
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
