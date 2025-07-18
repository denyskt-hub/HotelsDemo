//
//  XCTestCase+ImageDataLoader.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

protocol ImageDataLoaderTestCase {}

extension ImageDataLoaderTestCase where Self: XCTestCase {
	func expect(
		_ sut: ImageDataLoader,
		toLoad expectedResult: ImageDataLoader.LoadResult,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let exp = expectation(description: "Wait to complete")

		sut.load(url: anyURL()) { receivedResult in
			switch (receivedResult, expectedResult) {
			case let (.success(receivedData), .success(expectedData)):
				XCTAssertEqual(receivedData, expectedData, file: file, line: line)
			case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
				XCTAssertEqual(receivedError, expectedError, file: file, line: line)
			default:
				XCTFail("Expected \(expectedResult), got \(receivedResult)", file: file, line: line)
			}
			exp.fulfill()
		}

		action()

		wait(for: [exp], timeout: 1.0)
	}
}
