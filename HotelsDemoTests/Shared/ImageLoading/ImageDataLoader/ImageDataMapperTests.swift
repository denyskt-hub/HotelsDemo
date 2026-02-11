//
//  ImageDataMapperTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import XCTest
import HotelsDemo

final class ImageDataMapperTests: XCTestCase {
	func test_map_throwsInvalidDataErrorOnEmptyData() throws {
		XCTAssertThrowsError(
			try ImageDataMapper.map(emptyData())
		)
	}

	func test_map_deliversReceivedNonEmptyData() throws {
		let nonEmptyData = Data("non-empty data".utf8)

		let result = try ImageDataMapper.map(nonEmptyData)

		XCTAssertEqual(result, nonEmptyData)
	}
}
