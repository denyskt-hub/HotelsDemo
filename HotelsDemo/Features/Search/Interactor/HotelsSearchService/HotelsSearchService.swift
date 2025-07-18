//
//  HotelsSearchService.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchService {
	typealias Result = Swift.Result<[Hotel], Error>

	func search(criteria: SearchCriteria, completion: @escaping (Result) -> Void)
}
