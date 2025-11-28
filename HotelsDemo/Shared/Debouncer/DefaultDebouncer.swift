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
	private let currentSyncTask = Mutex<Task<Void, Never>?>(nil)
	private let currentAsyncTask = Mutex<Task<Void, Never>?>(nil)

	public init(delay: TimeInterval) {
		self.delay = delay
	}

	public func execute(_ action: @Sendable @escaping () -> Void) {
		currentSyncTask.withLock { task in
			task?.cancel()
			task = Task { @MainActor in
				try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
				guard !Task.isCancelled else { return }
				action()
			}
		}
	}

	public func asyncExecute(_ action: @Sendable @escaping () async -> Void) {
		currentAsyncTask.withLock { task in
			task?.cancel()
			task = Task {
				try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
				guard !Task.isCancelled else { return }
				await action()
			}
		}
	}
}
