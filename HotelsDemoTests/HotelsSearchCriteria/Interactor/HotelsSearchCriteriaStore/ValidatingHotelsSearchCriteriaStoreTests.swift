//
//  ValidatingHotelsSearchCriteriaStoreTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo
import Synchronization

final class ValidatingHotelsSearchCriteriaStoreTests: XCTestCase {
	func test_init_doesNotMessageStore() {
		let (_, store, _) = makeSUT()

		XCTAssertTrue(store.receivedMessages().isEmpty)
	}

	func test_save_validatesSearchCriteria() {
		let criteria = anySearchCriteria()
		let (sut, _, validator) = makeSUT()
		
		sut.save(criteria) { _ in }
		
		XCTAssertEqual(validator.validated(), [criteria])
	}

	func test_save_usesValidatedCriteriaForSaving() {
		let invalid = anySearchCriteria()
		let valid = makeSearchCriteria(checkInDate: "27.06.2025".date(), checkOutDate: "28.06.2025".date())
		let (sut, store, validator) = makeSUT()
		validator.stub(valid)

		sut.save(invalid) { _ in }

		XCTAssertEqual(store.receivedMessages(), [.save(valid)])
	}

	func test_save_deliversErrorOnStoreError() {
		let storeError = anyNSError()
		let (sut, store, _) = makeSUT()

		let exp = expectation(description: "Wait for completion")

		sut.save(anySearchCriteria()) { saveResult in
			switch saveResult {
			case let .failure(error):
				XCTAssertEqual(error as NSError, storeError)
			default:
				XCTFail("Expected to fail with store error")
			}

			exp.fulfill()
		}

		store.completeSave(with: .failure(storeError))

		wait(for: [exp], timeout: 1.0)
	}

	func test_save_deliversNoErrorOnSuccess() {
		let (sut, store, _) = makeSUT()

		let exp = expectation(description: "Wait for completion")
		
		sut.save(anySearchCriteria()) { saveResult in
			if case .failure = saveResult {
				XCTFail("Expected no error on successful save")
			}

			exp.fulfill()
		}

		store.completeSave(with: .success(()))

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
		validator.stub(valid)

		let exp = expectation(description: "Wait for completion")

		sut.retrieve { result in
			switch result {
			case let .success(retrieved):
				XCTAssertEqual(retrieved, valid)
				XCTAssertEqual(store.receivedMessages(), [.retrieve, .save(valid)])

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
		validator.stub(valid)

		let exp = expectation(description: "Wait for completion")

		sut.retrieve { result in
			switch result {
			case let .success(retrieved):
				XCTAssertEqual(retrieved, valid)
				XCTAssertEqual(store.receivedMessages(), [.retrieve])

			case let .failure(error):
				XCTFail("Expected success, got \(error) instead")
			}
			exp.fulfill()
		}

		store.completeRetrieve(with: .success(valid))

		wait(for: [exp], timeout: 1.0)
	}


	// MARK: - Helpers

	private func makeSUT() -> (
		sut: ValidatingHotelsSearchCriteriaStore,
		store: HotelsSearchCriteriaStoreSpy,
		validator: HotelsSearchCriteriaValidatorSpy
	) {
		let store = HotelsSearchCriteriaStoreSpy()
		let validator = HotelsSearchCriteriaValidatorSpy()
		let sut = ValidatingHotelsSearchCriteriaStore(
			decoratee: store,
			validator: validator
		)
		return (sut, store, validator)
	}
}

final class HotelsSearchCriteriaStoreSpy: HotelsSearchCriteriaStore {
	enum Message: Equatable {
		case save(HotelsSearchCriteria)
		case retrieve
	}

	private let messages = Mutex<[Message]>([])

	func receivedMessages() -> [Message] {
		messages.withLock { $0 }
	}

	private let saveCompletions = Mutex<[((SaveResult) -> Void)]>([])
	private let retrieveCompletions =  Mutex<[((RetrieveResult) -> Void)]>([])

	func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void) {
		messages.withLock { $0.append(.save(criteria)) }
		saveCompletions.withLock { $0.append(completion) }
	}
	
	func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		messages.withLock { $0.append(.retrieve) }
		retrieveCompletions.withLock { $0.append(completion) }
	}

	func completeSave(with result: SaveResult, at index: Int = 0) {
		saveCompletions.withLock({ $0 })[index](result)
	}

	func completeRetrieve(with result: RetrieveResult, at index: Int = 0) {
		retrieveCompletions.withLock({ $0 })[index](result)
	}
}

final class HotelsSearchCriteriaValidatorSpy: HotelsSearchCriteriaValidator {
	private let validatedCriterias = Mutex<[HotelsSearchCriteria]>([])
	private let stub = Mutex<HotelsSearchCriteria?>(nil)

	func validated() -> [HotelsSearchCriteria] {
		validatedCriterias.withLock { $0 }
	}

	func stub(_ stub: HotelsSearchCriteria) {
		self.stub.withLock { $0 = stub }
	}

	func validate(_ criteria: HotelsSearchCriteria) -> HotelsSearchCriteria {
		validatedCriterias.withLock { $0.append(criteria) }
		return stub.withLock({ $0 }) ?? criteria
	}
}
