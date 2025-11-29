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
		toLoadData expectedData: Data,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) async {
		action()

		do {
			let data = try await sut.load(url: anyURL())
			XCTAssertEqual(expectedData, data, file: file, line: line)
		} catch {
			XCTFail("Expected to load data, but got error instead: \(error)", file: file, line: line)
		}
	}

	func expect(
		_ sut: ImageDataLoader,
		toLoadTwice expectedResult: Result<Data, Error>,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) async {
		action()

		let url = anyURL()
		let firstTask = Task<Result<Data, Error>, Never> {
			do {
				let data = try await sut.load(url: url)
				return .success(data)
			} catch {
				return .failure(error)
			}
		}
		let secondTask = Task<Result<Data, Error>, Never> {
			do {
				let data = try await sut.load(url: url)
				return .success(data)
			} catch {
				return .failure(error)
			}
		}

		async let first = firstTask.value
		async let second = secondTask.value

		let firstResult = await first
		let secondResult = await second

		XCTAssertDataResultEqual(firstResult, expectedResult, file: file, line: line)
		XCTAssertDataResultEqual(secondResult, expectedResult, file: file, line: line)
	}

	func expect(
		_ sut: ImageDataLoader,
		toLoadWithError expectedError: Error,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) async {
		action()

		do {
			let data = try await sut.load(url: anyURL())
			XCTFail("Expected to load with an error, but got \(data) instead.", file: file, line: line)
		} catch {
			XCTAssertEqual(expectedError as NSError, error as NSError)
		}
	}

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
