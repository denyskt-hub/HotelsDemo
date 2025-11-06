//
//  Debouncer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/6/25.
//

import Foundation

public protocol Debouncer: Sendable {
	func execute(_ action: @Sendable @escaping () -> Void)
	func asyncExecute(_ action: @Sendable @escaping () async -> Void)
}
