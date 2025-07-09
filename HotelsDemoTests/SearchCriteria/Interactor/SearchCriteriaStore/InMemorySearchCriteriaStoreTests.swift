//
//  InMemorySearchCriteriaStoreTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 10/7/25.
//

import XCTest
import HotelsDemo

final class InMemorySearchCriteriaStoreTests: XCTestCase, SearchCriteriaStoreSpecs {
	func test_retrieve_deliversNotFoundErrorOnEmptyStore() {
		assertThatRetrieveDeliversNotFoundErrorOnEmptyStore(on: makeSUT())
	}

	func test_retrieve_deliversSavedCriteriaOnNonEmptyStore() {
		assertThatRetrieveDeliversSearchCriteriaOnNonEmptyStore(on: makeSUT())
	}

	func test_save_deliversNoErrorOnEmptyStore() {
		assertThatSaveDeliversNoErrorOnEmptyStore(on: makeSUT())
	}

	func test_save_deliversNoErrorOnNonEmptyStore() {
		assertThatSaveDeliversNoErrorOnNonEmptyStore(on: makeSUT())
	}

	func test_save_overridesPreviouslySavedCriteria() {
		assertThatSaveOverridesPreviouslySavedSearchCriteria(on: makeSUT())
	}

	func test_storeSideEffects_runsSerially() {
		assertThatStoreSideEffectsRunsSerially(on: makeSUT())
	}

	// MARK: - Helpers

	private func makeSUT() -> InMemorySearchCriteriaStore {
		InMemorySearchCriteriaStore(dispatcher: ImmediateDispatcher())
	}
}
