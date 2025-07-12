//
//  SearchCriteriaStoreSpecs.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 10/7/25.
//

import Foundation

protocol SearchCriteriaStoreSpecs {
	func test_retrieve_deliversNotFoundErrorOnEmptyStore()
	func test_retrieve_deliversSavedCriteriaOnNonEmptyStore()

	func test_save_deliversNoErrorOnEmptyStore()
	func test_save_deliversNoErrorOnNonEmptyStore()
	func test_save_overridesPreviouslySavedCriteria()

	func test_storeSideEffects_runsSerially()
}
