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
