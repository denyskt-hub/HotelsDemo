//
//  HotelsSearchCriteriaCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaCache {
	typealias SaveResult = Error?

	func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void)
}
