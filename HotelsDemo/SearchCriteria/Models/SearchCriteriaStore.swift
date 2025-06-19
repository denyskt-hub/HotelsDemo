//
//  SearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaStore {
	func set(_ criteria: SearchCriteria) throws
	func getCriteria() throws -> SearchCriteria?
}
