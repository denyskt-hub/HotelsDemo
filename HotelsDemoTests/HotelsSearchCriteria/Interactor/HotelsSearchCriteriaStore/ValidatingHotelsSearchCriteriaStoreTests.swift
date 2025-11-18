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

	func test_retrieve_deliversErrorOnStoreError() async throws {
		let storeError = anyNSError()
		let (sut, store, _) = makeSUT()
		store.stubRetrieve(.failure(storeError))

		do {
			_ = try await sut.retrieve()
		} catch {
			XCTAssertEqual(error as NSError, storeError)
		}
	}

	func test_retrieve_deliversValidatedSearchCriteriaAndSavesItWhenStoredCriteriaIsInvalid() async throws {
		let invalid = anySearchCriteria()
		let valid = makeSearchCriteria(checkInDate: "27.06.2025".date(), checkOutDate: "28.06.2025".date())
		let (sut, store, validator) = makeSUT()
		store.stubRetrieve(.success(invalid))
		validator.stub(valid)

		let retrieved = try await sut.retrieve()
		XCTAssertEqual(retrieved, valid)
		XCTAssertEqual(store.receivedMessages(), [.retrieve, .save(valid)])
	}

	func test_retrieve_doesNotSaveIfCriteriaIsAlreadyValid() async throws {
		let valid = makeSearchCriteria(checkInDate: "27.06.2025".date(), checkOutDate: "28.06.2025".date())
		let (sut, store, validator) = makeSUT()
		store.stubRetrieve(.success(valid))
		validator.stub(valid)

		let retrieved = try await sut.retrieve()
		XCTAssertEqual(retrieved, valid)
		XCTAssertEqual(store.receivedMessages(), [.retrieve])
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

	private let saveStub = Mutex<Error?>(nil)
	private let retrieveStub = Mutex<RetrieveResult?>(nil)

	func receivedMessages() -> [Message] {
		messages.withLock { $0 }
	}

	func stubSave(_ stub: Error) {
		saveStub.withLock { $0 = stub }
	}

	func stubRetrieve(_ stub: RetrieveResult) {
		retrieveStub.withLock { $0 = stub }
	}

	private let saveCompletions = Mutex<[((SaveResult) -> Void)]>([])
	private let retrieveCompletions =  Mutex<[((RetrieveResult) -> Void)]>([])

	func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void) {
		messages.withLock { $0.append(.save(criteria)) }
		saveCompletions.withLock { $0.append(completion) }
	}

	func save(_ criteria: HotelsSearchCriteria) async throws {
		messages.withLock { $0.append(.save(criteria)) }

		if let error = saveStub.withLock({ $0 }) {
			throw error
		}
	}

	func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		messages.withLock { $0.append(.retrieve) }
		retrieveCompletions.withLock { $0.append(completion) }
	}

	func retrieve() async throws -> HotelsSearchCriteria {
		guard let retrieved = retrieveStub.withLock({ $0 }) else {
			fatalError("Set a stub value using stubRetrieve before calling retrieve")
		}

		messages.withLock { $0.append(.retrieve) }

		switch retrieved {
		case let .success(criteria):
			return criteria
		case let .failure(error):
			throw error
		}
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
