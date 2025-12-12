//
//  Debouncer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DefaultDebouncer: Debouncer {
	private let delay: TimeInterval

	private let syncTaskStore = TaskStore<Void, Never>()
	private let asyncTaskStore = TaskStore<Void, Never>()

	public init(delay: TimeInterval) {
		self.delay = delay
	}

	public func execute(_ action: @Sendable @escaping () -> Void) {
		let task = Task { @MainActor in
			try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
			guard !Task.isCancelled else { return }
			action()
		}
		Task {
			await syncTaskStore.setTask(task)
		}
	}

	public func asyncExecute(_ action: @Sendable @escaping () async -> Void) {
		let task = Task {
			try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
			guard !Task.isCancelled else { return }
			await action()
		}
		Task {
			await asyncTaskStore.setTask(task)
		}
	}
}
