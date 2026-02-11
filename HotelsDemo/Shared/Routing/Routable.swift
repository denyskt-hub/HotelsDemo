//
//  Routable.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 18/10/25.
//

import UIKit

@MainActor
public protocol Routable: AnyObject {
	func present(_ viewController: UIViewController)
	func show(_ viewController: UIViewController)
}

extension UIViewController: Routable {
	public func present(_ viewController: UIViewController) {
		present(viewController, animated: true)
	}

	public func show(_ viewController: UIViewController) {
		show(viewController, sender: nil)
	}
}
