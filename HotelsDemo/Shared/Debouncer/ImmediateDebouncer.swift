//
//  ImmediateDebouncer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/6/25.
//

import Foundation

public final class ImmediateDebouncer: Debouncer {
	public init() {
		// Required for initialization in tests
	}

	public func execute(_ action: @escaping () -> Void) {
		action()
	}
}
