//
//  UIViewController+ErrorMessage.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 13/7/25.
//

import UIKit

extension UIViewController {
	func displayErrorMessage(_ message: String) {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
}
