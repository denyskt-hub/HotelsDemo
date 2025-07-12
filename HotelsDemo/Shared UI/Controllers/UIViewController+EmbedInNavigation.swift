//
//  UIViewController+EmbedInNavigation.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

extension UIViewController {
	public func embeddedInNavigationController() -> UINavigationController {
		UINavigationController(rootViewController: self)
	}
}
