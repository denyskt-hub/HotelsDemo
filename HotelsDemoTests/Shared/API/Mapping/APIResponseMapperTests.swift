//
//  APIResponseMapperTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 14/6/26.
//

import XCTest
import HotelsDemo

final class APIResponseMapperTests: XCTestCase {
	func test_map_deliversDataOnSuccessStatus() throws {
		let data = makeJSONData([
			"status": true,
			"message": "ok",
			"data": ["value": "hello"]
		])

		let result: TestModel = try APIResponseMapper.map(data, anyHTTPURLResponse())

		XCTAssertEqual(result, TestModel(value: "hello"))
	}

	func test_map_throwsServerError_notDecoding_whenStatusIsFalse() {
		// Regression: a `status: false` body that decodes fine must surface as
		// .serverError. Previously the throw lived inside the do/catch and was
		// swallowed, mislabeling the server error as a decoding failure.
		let data = makeJSONData([
			"status": false,
			"message": "server boom",
			"data": ["value": "x"]
		])

		XCTAssertThrowsError(try APIResponseMapper.map(data, anyHTTPURLResponse()) as TestModel) { error in
			guard case AppError.api(.serverError(let message)) = error else {
				return XCTFail("Expected .api(.serverError), got \(error)")
			}
			XCTAssertEqual(message, "server boom")
		}
	}

	func test_map_throwsDecodingError_onInvalidJSON() {
		let data = invalidJSONData()

		XCTAssertThrowsError(try APIResponseMapper.map(data, anyHTTPURLResponse()) as TestModel) { error in
			guard case AppError.api(.decoding) = error else {
				return XCTFail("Expected .api(.decoding), got \(error)")
			}
		}
	}

	// MARK: - Helpers

	private struct TestModel: Decodable, Equatable {
		let value: String
	}
}
