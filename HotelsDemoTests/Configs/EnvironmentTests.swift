//
//  EnvironmentTests.swift
//  HotelsDemoTests
//

import XCTest
import HotelsDemo

final class EnvironmentTests: XCTestCase {
	func test_load_deliversConfigOnValidDictionary() throws {
		let config = try Environment.load(from: validDictionary())

		XCTAssertEqual(config.apiKey, "a-key")
		XCTAssertEqual(config.apiHost, "api.example.com")
		XCTAssertEqual(config.baseURL, URL(string: "https://api.example.com")!)
	}

	func test_load_throwsMissingKeyOnNilDictionary() {
		assertThrows(.missingKey("Info.plist"), loadingFrom: nil)
	}

	func test_load_throwsMissingKeyWhenKeyIsAbsent() {
		for key in ["API_KEY", "API_HOST", "BASE_URL"] {
			var dict = validDictionary()
			dict.removeValue(forKey: key)

			assertThrows(.missingKey(key), loadingFrom: dict)
		}
	}

	func test_load_throwsEmptyValueWhenValueIsEmpty() {
		for key in ["API_KEY", "API_HOST", "BASE_URL"] {
			var dict = validDictionary()
			dict[key] = ""

			assertThrows(.emptyValue(key), loadingFrom: dict)
		}
	}

	func test_load_throwsInvalidURLWhenBaseURLIsNotAbsolute() {
		// `https:` is what the xcconfig yields when the `$()` trick is omitted:
		// `//` starts a comment, so the host is silently eaten. Each of these
		// passes `URL(string:)` and then fails every request at runtime.
		let unusable = [
			"https:",
			"https://",
			"api.example.com",
			"/api/v1",
			"not a url",
			// Endpoints carry the whole base URL through, and the log redactor
			// masks query items and headers — not userinfo. Reject credentials
			// rather than let them reach the request log verbatim.
			"https://user:pw@api.example.com"
		]

		for value in unusable {
			var dict = validDictionary()
			dict["BASE_URL"] = value

			assertThrows(.invalidURL(value), loadingFrom: dict)
		}
	}

	func test_load_acceptsBaseURLWithPortAndPath() throws {
		var dict = validDictionary()
		dict["BASE_URL"] = "https://api.example.com:8443/v2"

		let config = try Environment.load(from: dict)

		XCTAssertEqual(config.baseURL, URL(string: "https://api.example.com:8443/v2")!)
	}

	func test_invalidURLError_describesTheXcconfigCommentPitfall() {
		let description = Environment.Error.invalidURL("https:").description

		XCTAssertTrue(description.contains("BASE_URL"))
		XCTAssertTrue(description.contains("$()"))
		XCTAssertTrue(description.contains("README"))
	}

	func test_emptyValueError_describesHowToConfigureSecrets() {
		let description = Environment.Error.emptyValue("BASE_URL").description

		XCTAssertTrue(description.contains("BASE_URL"))
		XCTAssertTrue(description.contains("Secrets.Template.xcconfig"))
		XCTAssertTrue(description.contains("README"))
	}

	// MARK: - Helpers

	private func validDictionary() -> [String: Any] {
		[
			"API_KEY": "a-key",
			"API_HOST": "api.example.com",
			"BASE_URL": "https://api.example.com"
		]
	}

	private func assertThrows(
		_ expectedError: Environment.Error,
		loadingFrom dict: [String: Any]?,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		XCTAssertThrowsError(try Environment.load(from: dict), file: file, line: line) { error in
			guard let environmentError = error as? Environment.Error else {
				return XCTFail("Expected Environment.Error, got \(error)", file: file, line: line)
			}

			XCTAssertEqual(
				environmentError.description,
				expectedError.description,
				file: file,
				line: line
			)
		}
	}
}
