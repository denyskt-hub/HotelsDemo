//
//  Int+Helpers.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11.12.2025.
//

import Foundation

public extension Int {
	func clamp(minValue: Int, maxValue: Int) -> Int {
		Swift.min(Swift.max(self, minValue), maxValue)
	}
}
