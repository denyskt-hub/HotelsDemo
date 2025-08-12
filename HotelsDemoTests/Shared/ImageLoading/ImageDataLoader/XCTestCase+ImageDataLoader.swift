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
			XCTAssertDataResultEqual(receivedResult, expectedResult, file: file, line: line)
			exp.fulfill()
		}

		action()

		wait(for: [exp], timeout: 1.0)
	}

	func expect(
		_ sut: ImageDataLoader,
		toLoadTwice expectedResult: ImageDataLoader.LoadResult,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let exp = expectation(description: "Wait to complete")
		exp.expectedFulfillmentCount = 2

		let url = anyURL()
		sut.load(url: url) { receivedResult in
			XCTAssertDataResultEqual(receivedResult, expectedResult, file: file, line: line)
			exp.fulfill()
		}

		sut.load(url: url) { receivedResult in
			XCTAssertDataResultEqual(receivedResult, expectedResult, file: file, line: line)
			exp.fulfill()
		}

		action()

		wait(for: [exp], timeout: 1.0)
	}
}

func XCTAssertDataResultEqual(
	_ lhsResult: Result<Data, Error>,
	_ rhsResult: Result<Data, Error>,
	file: StaticString = #file,
	line: UInt = #line
) {
	switch (lhsResult, rhsResult) {
	case let (.success(lhsData), .success(rhsData)):
		XCTAssertEqual(lhsData, rhsData, file: file, line: line)
	case let (.failure(lhsError as NSError), .failure(rhsError as NSError)):
		XCTAssertEqual(lhsError, rhsError, file: file, line: line)
	default:
		XCTFail("Expected equal results", file: file, line: line)
	}
}
