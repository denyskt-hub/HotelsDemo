//
//  ImageDataMapperTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import XCTest
import HotelsDemo

final class ImageDataMapperTests: XCTestCase {
	func test_map_throwsErrorOnNon200HTTPResponse() throws {
		let samples = [199, 201, 300, 400, 500]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try ImageDataMapper.map(anyData(), makeHTTPURLResponse(statusCode: code))
			)
		}
	}

	func test_map_throwsInvalidDataErrorOn200HTTPResponseWithEmptyData() throws {
		XCTAssertThrowsError(
			try ImageDataMapper.map(emptyData(), makeHTTPURLResponse(statusCode: 200))
		)
	}

	func test_map_deliversReceivedNonEmptyDataOn200HTTPResponse() throws {
		let nonEmptyData = Data("non-empty data".utf8)

		let result = try ImageDataMapper.map(nonEmptyData, makeHTTPURLResponse(statusCode: 200))

		XCTAssertEqual(result, nonEmptyData)
	}
}
