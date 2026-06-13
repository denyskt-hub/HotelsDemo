//
//  SensitiveDataRedactorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 14/6/26.
//

import XCTest
@testable import HotelsDemo

final class SensitiveDataRedactorTests: XCTestCase {

	// MARK: - Headers

	func test_redactedHeaderValue_masksSensitiveKeys() {
		XCTAssertEqual(SensitiveDataRedactor.redactedHeaderValue(key: "Authorization", value: "Bearer abc"), "***")
		XCTAssertEqual(SensitiveDataRedactor.redactedHeaderValue(key: "X-RapidAPI-Key", value: "my-key"), "***")
		XCTAssertEqual(SensitiveDataRedactor.redactedHeaderValue(key: "Cookie", value: "sid=1"), "***")
	}

	func test_redactedHeaderValue_keepsNonSensitiveKeys() {
		XCTAssertEqual(SensitiveDataRedactor.redactedHeaderValue(key: "Content-Type", value: "application/json"), "application/json")
		XCTAssertEqual(SensitiveDataRedactor.redactedHeaderValue(key: "Accept", value: "*/*"), "*/*")
	}

	// MARK: - URL query

	func test_redactedURLString_masksSensitiveQueryValuesKeepsRest() {
		let url = URL(string: "https://api.com/path?token=qsecret&city=paris")!

		let redacted = SensitiveDataRedactor.redactedURLString(url)

		XCTAssertFalse(redacted.contains("qsecret"), "sensitive query value must be masked")
		XCTAssertTrue(redacted.contains("token=***"))
		XCTAssertTrue(redacted.contains("city=paris"), "non-sensitive query must stay intact")
	}

	func test_redactedURLString_withoutQuery_returnsURLUnchanged() {
		let url = URL(string: "https://api.com/path")!

		XCTAssertEqual(SensitiveDataRedactor.redactedURLString(url), "https://api.com/path")
	}

	// MARK: - JSON body

	func test_redactedBody_masksSensitiveKeysRecursively() {
		let data = Data(#"{"password":"pw","city":"paris","auth":{"token":"t"}}"#.utf8)

		let redacted = SensitiveDataRedactor.redactedBody(data)

		XCTAssertFalse(redacted.contains("\"pw\""), "top-level sensitive value must be masked")
		XCTAssertFalse(redacted.contains("\"t\""), "nested sensitive value must be masked")
		XCTAssertTrue(redacted.contains("***"))
		XCTAssertTrue(redacted.contains("paris"), "non-sensitive value must stay intact")
	}

	func test_redactedBody_nonJSON_returnsOriginalString() {
		let data = Data("<html>error</html>".utf8)

		XCTAssertEqual(SensitiveDataRedactor.redactedBody(data), "<html>error</html>")
	}
}
