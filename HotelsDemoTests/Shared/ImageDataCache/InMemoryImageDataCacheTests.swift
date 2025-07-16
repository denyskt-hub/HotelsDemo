//
//  InMemoryImageDataCacheTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 16/7/25.
//

import XCTest
import HotelsDemo

final class InMemoryImageDataCacheTests: XCTestCase {
	func test_dataForKey_deliversNilOnEmptyCache() {
		let sut = makeSUT()

		let data = getData(from: sut, forKey: anyKey())

		XCTAssertNil(data)
	}

	func test_dataForKey_hasNoSideEffectsOnEmptyCache() {
		let sut = makeSUT()

		var data = getData(from: sut, forKey: anyKey())
		XCTAssertNil(data)

		data = getData(from: sut, forKey: anyKey())
		XCTAssertNil(data)
	}

	func test_dataForKey_deliversDataOnNonEmptyStore() {
		let (key, data) = (anyKey(), anyData())
		let sut = makeSUT()
		save(to: sut, data: data, forKey: key)

		let receivedData = getData(from: sut, forKey: key)

		XCTAssertEqual(receivedData, data)
	}

	func test_dataForKey_hasNoSideEffectsOnNonEmptyStore() {
		let (key, data) = (anyKey(), anyData())
		let sut = makeSUT()
		save(to: sut, data: data, forKey: key)

		var receivedData = getData(from: sut, forKey: key)
		XCTAssertEqual(receivedData, data)

		receivedData = getData(from: sut, forKey: key)
		XCTAssertEqual(receivedData, data)
	}

	// MARK: -

	func test_save_deliversNoErrorOnEmptyStore() {
		let sut = makeSUT()

		let error = save(to: sut, data: anyData(), forKey: anyKey())

		XCTAssertNil(error)
	}

	func test_save_deliversNoErrorOnNonEmptyStore() {
		let (key, data) = (anyKey(), anyData())
		let sut = makeSUT()
		save(to: sut, data: data, forKey: key)

		let error = save(to: sut, data: data, forKey: key)

		XCTAssertNil(error)
	}

	func test_save_overridesPreviouslyStoredData() {
		let (key, data) = (anyKey(), anyData())
		let sut = makeSUT()
		save(to: sut, data: data, forKey: key)

		let latestData = Data("some data".utf8)
		save(to: sut, data: latestData, forKey: key)

		let receivedData = getData(from: sut, forKey: key)
		XCTAssertEqual(receivedData, latestData)
	}

	// MARK: -

	func test_save_evictsLeastRecentlyUsedItemsOnCountLimitExceeded() {
		let sut = makeSUT(countLimit: 2)

		save(to: sut, data: anyData(), forKey: "a")
		save(to: sut, data: anyData(), forKey: "b")

		getData(from: sut, forKey: "a")

		save(to: sut, data: anyData(), forKey: "c")

		let a = getData(from: sut, forKey: "a")
		XCTAssertNotNil(a)

		let b = getData(from: sut, forKey: "b")
		XCTAssertNil(b)

		let c = getData(from: sut, forKey: "c")
		XCTAssertNotNil(c)
	}

	func test_save_evictsLeastRecentlyUsedItemsOnSizeLimitExceeded() {
		let sut = makeSUT(sizeLimitInBytes: 20)

		save(to: sut, data: Data(repeating: 1, count: 10), forKey: "a")
		save(to: sut, data: Data(repeating: 1, count: 10), forKey: "b")

		getData(from: sut, forKey: "a")

		save(to: sut, data: anyData(), forKey: "c")

		let a = getData(from: sut, forKey: "a")
		XCTAssertNotNil(a)

		let b = getData(from: sut, forKey: "b")
		XCTAssertNil(b)

		let c = getData(from: sut, forKey: "c")
		XCTAssertNotNil(c)
	}

	func test_save_respectsCountAndSizeLimit() async throws {
		let sut = makeSUT(countLimit: 2, sizeLimitInBytes: 10)

		save(to: sut, data: Data(repeating: 0, count: 6), forKey: "a")
		save(to: sut, data: Data(repeating: 1, count: 6), forKey: "b")
		save(to: sut, data: Data(repeating: 2, count: 1), forKey: "c")
		save(to: sut, data: Data(repeating: 2, count: 1), forKey: "d")

		let a = getData(from: sut, forKey: "a")
		XCTAssertNil(a, "Expect a to be evicted by size limit")

		let b = getData(from: sut, forKey: "b")
		XCTAssertNil(b, "Expect b to be evicted by count limit")

		let c = getData(from: sut, forKey: "c")
		XCTAssertNotNil(c)

		let d = getData(from: sut, forKey: "d")
		XCTAssertNotNil(d)
	}

	// MARK: - Helpers

	private func makeSUT(
		countLimit: Int? = nil,
		sizeLimitInBytes: Int? = nil
	) -> InMemoryImageDataCache {
		InMemoryImageDataCache(
			countLimit: countLimit,
			sizeLimitInBytes: sizeLimitInBytes
		)
	}

	@discardableResult
	private func save(to sut: ImageDataCache, data: Data, forKey key: String) -> Error? {
		let exp = expectation(description: "Wait for completion")

		var receivedError: Error?
		sut.save(data, forKey: key) { error in
			receivedError = error
			exp.fulfill()
		}

		wait(for: [exp], timeout: 0.1)
		return receivedError
	}

	@discardableResult
	private func getData(from sut: ImageDataCache, forKey key: String) -> Data? {
		let exp = expectation(description: "Wait for completion")

		var receivedData: Data?
		sut.data(forKey: key) { result in
			if case let .success(data) = result {
				receivedData = data
			}
			exp.fulfill()
		}

		wait(for: [exp], timeout: 0.1)
		return receivedData
	}
}

func anyKey() -> String {
	"any key"
}
