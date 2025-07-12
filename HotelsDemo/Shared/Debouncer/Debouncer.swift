//
//  Debouncer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/6/25.
//

import Foundation

public protocol Debouncer {
	func execute(_ action: @escaping () -> Void)
}
