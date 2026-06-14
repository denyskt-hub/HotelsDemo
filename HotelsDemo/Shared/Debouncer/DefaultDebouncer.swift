//
//  Debouncer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation
import Synchronization

public final class DefaultDebouncer: Debouncer {
	private let delay: TimeInterval
	private let currentTask = Mutex<Task<Void, Never>?>(nil)

	public init(delay: TimeInterval) {
		self.delay = delay
	}

	public func execute(_ action: @Sendable @escaping () -> Void) {
		schedule { action() }
	}

	public func asyncExecute(_ action: @Sendable @escaping () async -> Void) {
		schedule { await action() }
	}

	/// Cancels the pending task (if any) and schedules a new one, atomically.
	///
	/// Cancel-previous and store-new run inside a single `Mutex` critical
	/// section, so concurrent callers are ordered by lock acquisition and the
	/// debouncer's "only the last call fires" invariant always holds.
	private func schedule(_ action: @Sendable @escaping () async -> Void) {
		currentTask.withLock { task in
			task?.cancel()
			task = Task { [delay] in
				try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
				guard !Task.isCancelled else { return }
				await action()
			}
		}
	}
}
