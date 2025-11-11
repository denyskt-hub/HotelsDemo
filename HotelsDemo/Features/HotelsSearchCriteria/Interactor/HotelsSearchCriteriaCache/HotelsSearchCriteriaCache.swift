//
//  HotelsSearchCriteriaCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaCache: Sendable {
	typealias SaveResult = Result<Void, Error>

	func save(_ criteria: HotelsSearchCriteria, completion: @Sendable @escaping (SaveResult) -> Void)
}
