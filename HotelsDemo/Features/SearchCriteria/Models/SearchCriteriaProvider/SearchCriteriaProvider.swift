//
//  SearchCriteriaProvider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol SearchCriteriaProvider {
	typealias Result = Swift.Result<SearchCriteria, Error>

	func retrieve(completion: @escaping (Result) -> Void)
}
