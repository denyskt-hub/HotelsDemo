//
//  UIViewController+SimulateAppearance.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/7/25.
//

import UIKit

extension UIViewController {
	func simulateAppearance() {
		if !isViewLoaded {
			loadViewIfNeeded()
		}

		beginAppearanceTransition(true, animated: false)
		endAppearanceTransition()
	}

	func simulateAppearanceInWindow() {
		putInWindow(self)
		simulateAppearance()
	}

	@discardableResult
	func putInWindow(_ viewController: UIViewController) -> UIWindow {
		let window = UIWindow(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
		window.rootViewController = viewController
		window.isHidden = false
		waitForPresentation()
		return window
	}

	func waitForPresentation(timeout: TimeInterval = 0.1) {
		RunLoop.current.run(until: Date().addingTimeInterval(timeout))
	}

	/// Dismisses any presented view controller and lets the run loop tear the
	/// presentation down. UIKit's presentation graph strongly retains both the
	/// presenting and presented view controllers until dismissal completes,
	/// so presenting tests must call this to avoid leaking the SUT.
	func simulateDismissal(timeout: TimeInterval = 0.1) {
		guard presentedViewController != nil else { return }
		dismiss(animated: false)
		waitForPresentation(timeout: timeout)
	}
}
