//
//  DestinationSearchService.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

protocol DestinationSearchService {
	typealias Result = Swift.Result<[Destination], Error>

	func search(query: String, completion: @escaping (Result) -> Void)
}
