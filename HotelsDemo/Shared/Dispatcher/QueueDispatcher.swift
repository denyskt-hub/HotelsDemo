//
//  QueueDispatcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 18/7/25.
//

import Foundation

public final class QueueDispatcher: Dispatcher {
	private let queue: DispatchQueue

	public init(queue: DispatchQueue) {
		self.queue = queue
	}

	public func dispatch(_ action: @Sendable @escaping () -> Void) {
		queue.async { action() }
	}
}
