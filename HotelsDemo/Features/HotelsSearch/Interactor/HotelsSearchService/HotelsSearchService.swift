//
//  HotelsSearchService.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchService: Sendable {
	func search(criteria: HotelsSearchCriteria) async throws -> [Hotel]
}
