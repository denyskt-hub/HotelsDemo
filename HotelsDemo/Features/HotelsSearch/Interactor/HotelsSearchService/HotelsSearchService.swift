//
//  HotelsSearchService.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchService: Sendable {
	typealias Result = Swift.Result<[Hotel], Error>

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	@discardableResult
	func search(criteria: HotelsSearchCriteria, completion: @Sendable @escaping (Result) -> Void) -> HTTPClientTask
}
