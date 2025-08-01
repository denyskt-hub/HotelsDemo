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
			child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
			child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
		]
		constraints.forEach { $0.isActive = true }

		child.didMove(toParent: self)
	}

	func removeChild(_ child: UIViewController) {
		guard child.parent != nil else { return }

		child.willMove(toParent: nil)
		child.view.removeFromSuperview()
		child.removeFromParent()
	}

	func addChildren(_ children: [UIViewController], to stackView: UIStackView) {
		children.forEach { child in
			addChildToStack(child, stackView: stackView)
		}
	}

	func removeChildren(_ children: [UIViewController]) {
		children.forEach { child in
			removeChild(child)
		}
	}

	private func addChildToStack(_ child: UIViewController, stackView: UIStackView) {
		guard child.parent == nil else { return }

		addChild(child)

		stackView.addArrangedSubview(child.view)

		child.didMove(toParent: self)
	}
}
