//
//  MainQueueDispatcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 18/7/25.
//

import Foundation

public final class MainQueueDispatcher: Dispatcher {
	private let dispatcher = QueueDispatcher(queue: .main)

	public func dispatch(_ completion: @escaping () -> Void) {
		dispatcher.dispatch(completion)
	}
}
