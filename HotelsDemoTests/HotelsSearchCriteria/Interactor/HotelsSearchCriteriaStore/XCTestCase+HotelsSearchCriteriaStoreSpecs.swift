//
//  XCTestCase+HotelsSearchCriteriaStoreSpecs.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 10/7/25.
//

import XCTest
import HotelsDemo

extension HotelsSearchCriteriaStoreSpecs where Self: XCTestCase {
	func assertThatRetrieveDeliversNotFoundErrorOnEmptyStore(
		on sut: HotelsSearchCriteriaStore,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		expect(sut, toRetrieve: .failure(SearchCriteriaError.notFound), file: file, line: line)
	}

	func assertThatRetrieveDeliversSearchCriteriaOnNonEmptyStore(
		on sut: HotelsSearchCriteriaStore,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let criteria = anySearchCriteria()
		save(criteria, to: sut)

		expect(sut, toRetrieve: .success(criteria), file: file, line: line)
	}

	func assertThatSaveDeliversNoErrorOnEmptyStore(
		on sut: HotelsSearchCriteriaStore,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let saveResult = save(anySearchCriteria(), to: sut)

		assertSaveResultEqual(saveResult, .success(()), "Expected to save criteria successfully", file: file, line: line)
	}

	func assertThatSaveDeliversNoErrorOnNonEmptyStore(
		on sut: HotelsSearchCriteriaStore,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		save(anySearchCriteria(), to: sut)

		let saveResult = save(anySearchCriteria(), to: sut)

		assertSaveResultEqual(saveResult, .success(()), "Expected to override criteria successfully", file: file, line: line)
	}

	func assertThatSaveOverridesPreviouslySavedSearchCriteria(
		on sut: HotelsSearchCriteriaStore,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		save(anySearchCriteria(), to: sut)

		let latestCriteria = anySearchCriteria()
		save(latestCriteria, to: sut)

		expect(sut, toRetrieve: .success(latestCriteria), file: file, line: line)
	}

	func assertThatStoreSideEffectsRunsSerially(
		on sut: HotelsSearchCriteriaStore,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
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

		XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order", file: file, line: line)
	}

	private func assertSaveResultEqual(
		_ result: HotelsSearchCriteriaStore.SaveResult,
		_ expectedResult: HotelsSearchCriteriaStore.SaveResult,
		_ message: String = "",
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		switch (result, expectedResult) {
		case (.success, .success):
			return
		case let (.failure(error as NSError), .failure(expectedError as NSError)):
			XCTAssertEqual(error, expectedError, file: file, line: line)
		default:
			XCTFail(message, file: file, line: line)
		}
	}
}

extension HotelsSearchCriteriaStoreSpecs where Self: XCTestCase {
	func expect(
		_ sut: HotelsSearchCriteriaStore,
		toRetrieve expectedResult: HotelsSearchCriteriaProvider.RetrieveResult,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let retrievedResult = retrieve(from: sut)

		switch (retrievedResult, expectedResult) {
		case let (.success(retrievedCriteria), .success(expectedCritera)):
			XCTAssertEqual(retrievedCriteria, expectedCritera, file: file, line: line)
		case let (.failure(retreivedError as NSError), .failure(expectedError as NSError)):
			XCTAssertEqual(expectedError.domain, retreivedError.domain, file: file, line: line)
			XCTAssertEqual(expectedError.code, retreivedError.code, file: file, line: line)
		default:
			XCTFail("Unexpected combination: \(retrievedResult), \(expectedResult)", file: file, line: line)
		}
	}

	func retrieve(from sut: HotelsSearchCriteriaStore) -> HotelsSearchCriteriaProvider.RetrieveResult {
		let exp = expectation(description: "Wait for retrieve")

		var retrievedResult: HotelsSearchCriteriaProvider.RetrieveResult!

		Task {
			do {
				let criteria = try await sut.retrieve()
				retrievedResult = .success(criteria)
			} catch {
				retrievedResult = .failure(error as NSError)
			}
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
		return retrievedResult
	}

	@discardableResult
	func save(_ criteria: HotelsSearchCriteria, to sut: HotelsSearchCriteriaStore) -> HotelsSearchCriteriaStore.SaveResult {
		let exp = expectation(description: "Wait for save")

		var saveResult: HotelsSearchCriteriaStore.SaveResult!
		sut.save(criteria) { result in
			saveResult = result
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
		return saveResult
	}
}
