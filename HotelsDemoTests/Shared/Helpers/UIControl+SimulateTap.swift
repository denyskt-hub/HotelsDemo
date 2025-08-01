//
//  UIControl+SimulateTap.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/7/25.
//

import UIKit

extension UIControl {
	func simulateTap() {
		simulate(event: .touchUpInside)
	}

	func simulate(event: UIControl.Event) {
		allTargets.forEach { target in
			actions(forTarget: target, forControlEvent: event)?.forEach {
				(target as NSObject).perform(Selector($0))
			}
		}
	}
}
