//
//  UIButton+Badge.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/8/25.
//

import UIKit

extension UIButton {
	func setBadgeVisible(_ isVisible: Bool) {
		subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }

		guard isVisible, let titleLabel = self.titleLabel else { return }

		let dotSize: CGFloat = 8
		let dot = UIView()
		dot.tag = 999
		dot.translatesAutoresizingMaskIntoConstraints = false
		dot.backgroundColor = .systemRed
		dot.layer.cornerRadius = dotSize / 2
		dot.layer.borderWidth = 1.5
		dot.layer.borderColor = UIColor.white.cgColor
		dot.isUserInteractionEnabled = false

		addSubview(dot)

		NSLayoutConstraint.activate([
			dot.widthAnchor.constraint(equalToConstant: dotSize),
			dot.heightAnchor.constraint(equalToConstant: dotSize),
			dot.centerXAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
			dot.centerYAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 0)
		])
	}
}
