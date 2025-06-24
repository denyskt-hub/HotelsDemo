//
//  SearchCriteriaValidator.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol SearchCriteriaValidator {
	func validate(_ criteria: SearchCriteria) -> SearchCriteria
}
