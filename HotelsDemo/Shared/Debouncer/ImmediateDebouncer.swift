//
//  ImmediateDebouncer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 28/6/25.
//

import Foundation

public final class ImmediateDebouncer: Debouncer {
	public init() {}
	
	public func execute(_ action: @escaping () -> Void) {
		action()
	}
}
