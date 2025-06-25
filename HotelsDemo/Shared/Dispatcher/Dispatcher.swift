//
//  Dispatcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol Dispatcher {
	func dispatch(_ action: @escaping () -> Void)
}

public final class ImmediateDispatcher: Dispatcher {
	public init() {}
	
	public func dispatch(_ action: @escaping () -> Void) {
		action()
	}
}

public final class QueueDispatcher: Dispatcher {
	private let queue: DispatchQueue

	public init(queue: DispatchQueue) {
		self.queue = queue
	}

	public func dispatch(_ action: @escaping () -> Void) {
		queue.async { action() }
	}
}

public final class MainQueueDispatcher: Dispatcher {
	private let dispatcher = QueueDispatcher(queue: .main)

	public func dispatch(_ completion: @escaping () -> Void) {
		dispatcher.dispatch(completion)
	}
}
