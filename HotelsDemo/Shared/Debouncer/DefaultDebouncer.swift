//
//  Debouncer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DefaultDebouncer: Debouncer {
	private var workItem: DispatchWorkItem?
	private let queue: DispatchQueue
	private let delay: TimeInterval

	public init(
		delay: TimeInterval,
		queue: DispatchQueue = .main
	) {
		self.delay = delay
		self.queue = queue
	}

	public func execute(_ action: @escaping () -> Void) {
		workItem?.cancel()
		let item = DispatchWorkItem(block: action)
		workItem = item
		queue.asyncAfter(deadline: .now() + delay, execute: item)
	}

	private var currentTask: Task<Void, Error>?

	public func asyncExecute(_ action: @Sendable @escaping () async throws -> Void) {
		currentTask?.cancel()
		currentTask = Task {
			try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
			try await action()
		}
	}
}
