//
//  main.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12.02.2026.
//

import UIKit

private func isRunningTests() -> Bool {
	ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}

let appDelegateClass: AnyClass =
	isRunningTests() ? TestAppDelegate.self : AppDelegate.self

UIApplicationMain(
	CommandLine.argc,
	CommandLine.unsafeArgv,
	nil,
	NSStringFromClass(appDelegateClass)
)
