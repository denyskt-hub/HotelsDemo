//
//  HotelsSearchCriteriaValidator.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaValidator {
	func validate(_ criteria: HotelsSearchCriteria) -> HotelsSearchCriteria
}
