//
//  ValidatingSearchCriteriaStoreTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo

final class ValidatingSearchCriteriaStoreTests: XCTestCase {
	func test_init_doesNotMessageStore() {
		let (_, store, _) = makeSUT()

		XCTAssertTrue(store.messages.isEmpty)
	}

	func test_save_delegatesToStore() {
		let criteria = anySearchCriteria()
		let (sut, store, _) = makeSUT()
		
		sut.save(criteria) { _ in }

		XCTAssertEqual(store.messages, [.save(criteria)])
	}

	func test_save_deliversErrorOnStoreError() {
		let storeError = anyNSError()
		let (sut, store, _) = makeSUT()

		let exp = expectation(description: "Wait for completion")

		sut.save(anySearchCriteria()) { error in
			XCTAssertEqual(error as? NSError, storeError)
			exp.fulfill()
		}

		store.completeSave(with: storeError)

		wait(for: [exp], timeout: 1.0)
	}

	// MARK: - Helpers

	private func makeSUT() -> (sut: ValidatingSearchCriteriaStore, store: SearchCriteriaStoreSpy, validator: SearchCriteriaValidatorSpy) {
		let store = SearchCriteriaStoreSpy()
		let validator = SearchCriteriaValidatorSpy()
		let sut = ValidatingSearchCriteriaStore(
			decoratee: store,
			validator: validator
		)
		return (sut, store, validator)
	}

	private func anyNSError() -> NSError {
		NSError(domain: "test", code: 1)
	}
}

final class SearchCriteriaStoreSpy: SearchCriteriaStore {
	enum Message: Equatable {
		case save(SearchCriteria)
		case retrieve
	}

	private(set) var messages: [Message] = []

	private var saveCompletions: [((SaveResult) -> Void)] = []
	private var retrieveCompletions: [((RetrieveResult) -> Void)] = []

	func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void) {
		messages.append(.save(criteria))
		saveCompletions.append(completion)
	}
	
	func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		messages.append(.retrieve)
		retrieveCompletions.append(completion)
	}

	func completeSave(with result: SaveResult, at index: Int = 0) {
		saveCompletions[index](result)
	}

	func completeRetrieve(with result: RetrieveResult, at index: Int = 0) {
		retrieveCompletions[index](result)
	}
}

final class SearchCriteriaValidatorSpy: SearchCriteriaValidator {
	func validate(_ criteria: SearchCriteria) -> SearchCriteria {
		return criteria
	}
}
