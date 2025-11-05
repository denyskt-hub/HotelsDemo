//
//  Debouncer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/6/25.
//

import Foundation

public protocol Debouncer: Sendable {
	func execute(_ action: @escaping () -> Void)
	func asyncExecute<T>(_ action: @escaping () async throws -> T) async throws -> T
}

extension Debouncer {
	public func asyncExecute<T>(_ action: @escaping () async throws -> T) async throws -> T {
		try await action()
	}
}
