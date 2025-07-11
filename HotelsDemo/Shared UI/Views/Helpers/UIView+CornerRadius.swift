//
//  UIView+CornerRadius.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11/7/25.
//

import UIKit

enum Corner {
	case topLeft
	case topRight
	case bottomLeft
	case bottomRight
}

extension UIView {
	func roundCorners(_ corners: [Corner], radius: CGFloat = 8) {
		layer.cornerRadius = radius
		layer.maskedCorners = CACornerMask(from: corners)
		layer.masksToBounds = true
	}

	func roundAllCorners(radius: CGFloat = 8) {
		roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: radius)
	}

	func clearCornerRadius() {
		layer.cornerRadius = 0
		layer.maskedCorners = []
	}
}

private extension CACornerMask {
	init(from corners: [Corner]) {
		self = []

		for corner in corners {
			switch corner {
			case .topLeft: self.insert(.layerMinXMinYCorner)
			case .topRight: self.insert(.layerMaxXMinYCorner)
			case .bottomLeft: self.insert(.layerMinXMaxYCorner)
			case .bottomRight: self.insert(.layerMaxXMaxYCorner)
			}
		}
	}
}
