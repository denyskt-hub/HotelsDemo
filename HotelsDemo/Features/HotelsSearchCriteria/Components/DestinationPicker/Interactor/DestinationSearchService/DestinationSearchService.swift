//
//  DestinationSearchService.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol DestinationSearchService: Sendable {
	func search(query: String) async throws -> [Destination]
}
