//
//  SearchCriteriaCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol SearchCriteriaCache {
	typealias SaveResult = Error?
	
	func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void)
}
