//
//  UIActivityIndicatorView+Helpers.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import UIKit

extension UIActivityIndicatorView {
	func show(in view: UIView) {
		view.addSubview(self)

		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			centerXAnchor.constraint(equalTo: view.centerXAnchor),
			centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])

		startAnimating()
	}

	func hide() {
		stopAnimating()
		removeFromSuperview()
	}
}
