//
//  DispatchingDecorator.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/8/25.
//

import Foundation

public final class DispatchingDecorator<T> {
	internal let decoratee: T
	private let dispatcher: Dispatcher

	public init(
		decoratee: T,
		dispatcher: Dispatcher
	) {
		self.decoratee = decoratee
		self.dispatcher = dispatcher
	}

	public func dispatching<Output>(_ completion: @Sendable @escaping (Output) -> Void) -> @Sendable (Output) -> Void {
		{ [weak self] value in
			self?.dispatcher.dispatch {
				completion(value)
			}
		}
	}
}
