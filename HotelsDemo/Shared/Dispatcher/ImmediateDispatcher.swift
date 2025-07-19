//
//  ImmediateDispatcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 18/7/25.
//

import Foundation

public final class ImmediateDispatcher: Dispatcher {
	public init() {
		// Required for initialization in tests
	}

	public func dispatch(_ action: @escaping () -> Void) {
		action()
	}
}
