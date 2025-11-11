//
//  Dispatcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol Dispatcher: Sendable {
	func dispatch(_ action: @Sendable @escaping () -> Void)
}
