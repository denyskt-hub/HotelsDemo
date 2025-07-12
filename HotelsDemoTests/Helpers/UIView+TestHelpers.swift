//
//  UIView+TestHelpers.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 9/7/25.
//

import UIKit

extension UIView {
	func enforceLayoutCycle() {
		layoutIfNeeded()
		RunLoop.main.run(until: Date())
	}
}
