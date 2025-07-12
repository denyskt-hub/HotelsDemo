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

	func test_save_validatesSearchCriteria() {
		let criteria = anySearchCriteria()
		let (sut, _, validator) = makeSUT()
		
		sut.save(criteria) { _ in }
		
		XCTAssertEqual(validator.validated, [criteria])
	}

	func test_save_usesValidatedCriteriaForSaving() {
		let invalid = anySearchCriteria()
		let valid = makeSearchCriteria(checkInDate: "27.06.2025".date(), checkOutDate: "28.06.2025".date())
		let (sut, store, validator) = makeSUT()
		validator.stubbedResult = valid

		sut.save(invalid) { _ in }

		XCTAssertEqual(store.messages, [.save(valid)])
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

	func test_save_deliversNoErrorOnSuccess() {
		let (sut, store, _) = makeSUT()

		let exp = expectation(description: "Wait for completion")
		
		sut.save(anySearchCriteria()) { error in
			XCTAssertNil(error, "Expected no error on successful save")
			exp.fulfill()
		}

		store.completeSave(with: nil)

		wait(for: [exp], timeout: 1.0)
	}

	func test_retrieve_deliversErrorOnStoreError() {
		let storeError = anyNSError()
		let (sut, store, _) = makeSUT()

		let exp = expectation(description: "Wait for completion")

		sut.retrieve { result in
			switch result {
			case .success:
				XCTFail("Expected failure")
			case let .failure(error):
				XCTAssertEqual(error as NSError, storeError)
			}
			exp.fulfill()
		}

		store.completeRetrieve(with: .failure(storeError))

		wait(for: [exp], timeout: 1.0)
	}

	func test_retrieve_deliversValidatedSearchCriteriaAndSavesItWhenStoredCriteriaIsInvalid() {
		let invalid = anySearchCriteria()
		let valid = makeSearchCriteria(checkInDate: "27.06.2025".date(), checkOutDate: "28.06.2025".date())
		let (sut, store, validator) = makeSUT()
		validator.stubbedResult = valid

		let exp = expectation(description: "Wait for completion")

		sut.retrieve { result in
			switch result {
			case let .success(retrieved):
				XCTAssertEqual(retrieved, valid)
				XCTAssertEqual(store.messages, [.retrieve, .save(valid)])

			case let .failure(error):
				XCTFail("Expected success, got \(error) instead")
			}
			exp.fulfill()
		}

		store.completeRetrieve(with: .success(invalid))

		wait(for: [exp], timeout: 1.0)
	}

	func test_retrieve_doesNotSaveIfCriteriaIsAlreadyValid() {
		let valid = makeSearchCriteria(checkInDate: "27.06.2025".date(), checkOutDate: "28.06.2025".date())
		let (sut, store, validator) = makeSUT()
		validator.stubbedResult = valid

		let exp = expectation(description: "Wait for completion")

		sut.retrieve { result in
			switch result {
			case let .success(retrieved):
				XCTAssertEqual(retrieved, valid)
				XCTAssertEqual(store.messages, [.retrieve])

			case let .failure(error):
				XCTFail("Expected success, got \(error) instead")
			}
			exp.fulfill()
		}

		store.completeRetrieve(with: .success(valid))

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
	private(set) var validated = [SearchCriteria]()

	var stubbedResult: SearchCriteria?

	func validate(_ criteria: SearchCriteria) -> SearchCriteria {
		validated.append(criteria)
		return stubbedResult ?? criteria
	}
}
