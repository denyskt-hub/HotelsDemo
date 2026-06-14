//
//  LoggingHTTPClientTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 14/6/26.
//

import XCTest
@testable import HotelsDemo

final class LoggingHTTPClientTests: XCTestCase {
	func test_curlRepresentation_redactsSensitiveHeaders_keepsRest() {
		var request = URLRequest(url: URL(string: "https://api.com/path")!)
		request.setValue("Bearer secret-token", forHTTPHeaderField: "Authorization")
		request.setValue("my-rapid-key", forHTTPHeaderField: "X-RapidAPI-Key")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		let sut = makeSUT()

		let curl = sut.curlRepresentation(of: request)

		XCTAssertFalse(curl.contains("secret-token"), "Authorization value must be redacted")
		XCTAssertFalse(curl.contains("my-rapid-key"), "API key header value must be redacted")
		XCTAssertTrue(curl.contains("application/json"), "non-sensitive header must stay intact")
	}

	func test_curlRepresentation_redactsSensitiveQueryAndBody() {
		var request = URLRequest(url: URL(string: "https://api.com/path?token=qsecret&city=paris")!)
		request.httpMethod = "POST"
		request.httpBody = Data(#"{"password":"pw","city":"paris"}"#.utf8)
		let sut = makeSUT()

		let curl = sut.curlRepresentation(of: request)

		XCTAssertFalse(curl.contains("qsecret"), "sensitive query value must be redacted")
		XCTAssertFalse(curl.contains("\"pw\""), "sensitive body value must be redacted")
		XCTAssertTrue(curl.contains("paris"), "non-sensitive data must stay intact")
	}

	// MARK: - Helpers

	private func makeSUT() -> LoggingHTTPClient {
		LoggingHTTPClient(client: DummyHTTPClient())
	}

	private struct DummyHTTPClient: HTTPClient {
		func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
			fatalError("Not expected to perform a request in these tests")
		}
	}
}
