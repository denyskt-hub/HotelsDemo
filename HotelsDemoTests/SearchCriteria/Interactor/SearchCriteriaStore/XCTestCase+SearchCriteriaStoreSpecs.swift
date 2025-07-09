//
//  XCTestCase+SearchCriteriaStoreSpecs.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 10/7/25.
//

import XCTest
import HotelsDemo

extension SearchCriteriaStoreSpecs where Self: XCTestCase {
	func expect(_ sut: SearchCriteriaStore, toRetrieve expectedResult: SearchCriteriaProvider.RetrieveResult) {
		let retrievedResult = retrieve(from: sut)

		switch (retrievedResult, expectedResult) {
		case let (.success(retrievedCriteria), .success(expectedCritera)):
			XCTAssertEqual(retrievedCriteria, expectedCritera)
		case let (.failure(retreivedError as NSError), .failure(expectedError as NSError)):
			XCTAssertEqual(expectedError.domain, retreivedError.domain)
			XCTAssertEqual(expectedError.code, retreivedError.code)
		default:
			XCTFail("Unexpected combination: \(retrievedResult), \(expectedResult)")
		}
	}

	func retrieve(from sut: SearchCriteriaStore) -> SearchCriteriaProvider.RetrieveResult {
		let exp = expectation(description: "Wait for retrieve")

		var retrievedResult: SearchCriteriaProvider.RetrieveResult!
		sut.retrieve { result in
			retrievedResult = result
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
		return retrievedResult
	}

	func save(_ criteria: SearchCriteria, to sut: SearchCriteriaStore) {
		let exp = expectation(description: "Wait for save")

		sut.save(criteria) { _ in
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
	}
}
