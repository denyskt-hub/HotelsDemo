//
//  CodableSearchCriteriaStoreTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 25/6/25.
//

import XCTest
import HotelsDemo

final class CodableSearchCriteriaStoreTests: XCTestCase, SearchCriteriaStoreSpecs {
	override func setUp() {
		super.setUp()

		setupEmptyStoreState()
	}

	override func tearDown() {
		super.tearDown()

		undoStoreSideEffects()
	}

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

	private func makeSUT() -> CodableSearchCriteriaStore {
		CodableSearchCriteriaStore(
			storeURL: testSpecificStoreURL(),
			dispatcher: ImmediateDispatcher()
		)
	}

	private func setupEmptyStoreState() {
		deleteStoreArtifacts()
	}

	private func undoStoreSideEffects() {
		deleteStoreArtifacts()
	}

	private func deleteStoreArtifacts() {
		try? FileManager.default.removeItem(at: testSpecificStoreURL())
	}

	private func testSpecificStoreURL() -> URL {
		cachesDirectory().appendingPathComponent("\(type(of: self)).store")
	}

	private func cachesDirectory() -> URL {
		FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
	}
}
