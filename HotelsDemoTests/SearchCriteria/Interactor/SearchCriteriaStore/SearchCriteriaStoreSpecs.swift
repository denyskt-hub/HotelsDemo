//
//  SearchCriteriaStoreSpecs.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 10/7/25.
//

import Foundation

protocol SearchCriteriaStoreSpecs {
	func test_retrieve_deliversNotFoundErrorOnEmptyStore()
	func test_retrieve_deliversSavedCriteria()
	func test_save_overridesPreviouslySavedCriteria() 
}
