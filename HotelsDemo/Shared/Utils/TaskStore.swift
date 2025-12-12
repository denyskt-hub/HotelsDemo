//
//  TaskStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12.12.2025.
//

import Foundation

public actor TaskStore<Success: Sendable, Failure: Error> {
	private var task: Task<Success, Failure>?

	public init() {}

	/// Cancels the current task if one exists and sets a new task.
	/// - Parameter task: The new task to store
	public func setTask(_ task: Task<Success, Failure>) {
		self.task?.cancel()
		self.task = task
	}

	/// Cancels the current task if one exists and clears it.
	public func cancel() {
		task?.cancel()
		task = nil
	}
}
