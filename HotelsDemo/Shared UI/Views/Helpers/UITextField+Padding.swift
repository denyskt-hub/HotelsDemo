//
//  UITextField+Padding.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11/7/25.
//

import UIKit

extension UITextField {
	func setLeftPadding(_ padding: CGFloat) {
		leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
		leftViewMode = .always
	}

	func setRightPadding(_ padding: CGFloat) {
		rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
		rightViewMode = .always
	}
}
