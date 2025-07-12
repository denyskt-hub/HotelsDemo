//
//  UIViewController+Child.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public extension UIViewController {
	func addChild(_ child: UIViewController, to containerView: UIView) {
		guard child.parent == nil else { return }

		addChild(child)
		containerView.addSubview(child.view)

		child.view.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			containerView.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
			containerView.topAnchor.constraint(equalTo: child.view.topAnchor),
			containerView.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
		]
		constraints.forEach { $0.isActive = true }
		containerView.addConstraints(constraints)

		child.didMove(toParent: self)
	}

	func removeChild(_ child: UIViewController) {
		guard child.parent != nil else { return }

		child.willMove(toParent: nil)
		child.view.removeFromSuperview()
		child.removeFromParent()
	}
}
