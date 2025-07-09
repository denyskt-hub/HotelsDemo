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
		let sut = makeSUT()

		expect(sut, toRetrieve: .failure(SearchCriteriaError.notFound))
	}

	func test_retrieve_deliversSavedCriteria() {
		let sut = makeSUT()
		
		let criteria = anySearchCriteria()
		save(criteria, to: sut)

		expect(sut, toRetrieve: .success(criteria))
	}

	func test_save_overridesPreviouslySavedCriteria() {
		let sut = makeSUT()
		
		let firstCriteria = anySearchCriteria()
		let latestCriteria = anySearchCriteria()

		save(firstCriteria, to: sut)
		save(latestCriteria, to: sut)

		expect(sut, toRetrieve: .success(latestCriteria))
	}

	func test_storeSideEffects_runSerially() {
		let sut = makeSUT()
		var completedOperationsInOrder = [XCTestExpectation]()

		let op1 = expectation(description: "Operation 1")
		sut.save(anySearchCriteria()) { _ in
			completedOperationsInOrder.append(op1)
			op1.fulfill()
		}

		let op2 = expectation(description: "Operation 2")
		sut.save(anySearchCriteria()) { _ in
			completedOperationsInOrder.append(op2)
			op2.fulfill()
		}

		let op3 = expectation(description: "Operation 3")
		sut.save(anySearchCriteria()) { _ in
			completedOperationsInOrder.append(op3)
			op3.fulfill()
		}

		waitForExpectations(timeout: 5.0)

		XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
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
