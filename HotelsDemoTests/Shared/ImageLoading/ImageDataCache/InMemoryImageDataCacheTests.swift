//
//  InMemoryImageDataCacheTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 16/7/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class InMemoryImageDataCacheTests: XCTestCase {
	func test_dataForKey_deliversNilOnEmptyCache() async throws {
		let sut = makeSUT()

		let data = try await getData(from: sut, forKey: anyKey())

		XCTAssertNil(data)
	}

	func test_dataForKey_hasNoSideEffectsOnEmptyCache() async throws {
		let sut = makeSUT()

		var data = try await getData(from: sut, forKey: anyKey())
		XCTAssertNil(data)

		data = try await getData(from: sut, forKey: anyKey())
		XCTAssertNil(data)
	}

	func test_dataForKey_deliversDataOnNonEmptyStore() async throws {
		let (key, data) = (anyKey(), anyData())
		let sut = makeSUT()
		try await save(to: sut, data: data, forKey: key)

		let receivedData = try await getData(from: sut, forKey: key)

		XCTAssertEqual(receivedData, data)
	}

	func test_dataForKey_hasNoSideEffectsOnNonEmptyStore() async throws {
		let (key, data) = (anyKey(), anyData())
		let sut = makeSUT()
		try await save(to: sut, data: data, forKey: key)

		var receivedData = try await getData(from: sut, forKey: key)
		XCTAssertEqual(receivedData, data)

		receivedData = try await getData(from: sut, forKey: key)
		XCTAssertEqual(receivedData, data)
	}

	// MARK: -

	func test_save_deliversNoErrorOnEmptyStore() async throws {
		let sut = makeSUT()

		try await save(to: sut, data: anyData(), forKey: anyKey())

		// No assert — passes if it doesn’t crash or hang
	}

	func test_save_deliversNoErrorOnNonEmptyStore() async throws {
		let (key, data) = (anyKey(), anyData())
		let sut = makeSUT()
		try await save(to: sut, data: data, forKey: key)

		try await save(to: sut, data: data, forKey: key)

		// No assert — passes if it doesn’t crash or hang
	}

	func test_save_overridesPreviouslyStoredData() async throws {
		let (key, data) = (anyKey(), anyData())
		let sut = makeSUT()
		try await save(to: sut, data: data, forKey: key)

		let latestData = Data("some data".utf8)
		try await save(to: sut, data: latestData, forKey: key)

		let receivedData = try await getData(from: sut, forKey: key)
		XCTAssertEqual(receivedData, latestData)
	}

	// MARK: -

	func test_save_doesNotCauseDataRaces() async throws {
		let data = anyData()
		let sut = makeSUT(countLimit: 100)

		let taskCount = 100
		await withTaskGroup(of: Void.self) { group in
			for i in 0..<taskCount {
				group.addTask {
					try? await sut.save(data, forKey: "key-\(i)")
				}
			}
		}

		for i in 0..<taskCount {
			let result = try await getData(from: sut, forKey: "key-\(i)")
			XCTAssertEqual(result, data, "Data mismatch at key-\(i)")
		}
	}

	func test_data_isThreadSafe() async throws {
		let key = anyKey()
		let sut = makeSUT()

		try await save(to: sut, data: anyData(), forKey: key)

		await withTaskGroup(of: Void.self) { group in
			for _ in 0..<1000 {
				group.addTask {
					_ = try? await sut.data(forKey: key)
				}
			}
		}

		// No assert — passes if it doesn’t crash or hang
	}

	// MARK: -

	func test_save_evictsLeastRecentlyUsedItemsOnCountLimitExceeded() async throws {
		let sut = makeSUT(countLimit: 2)

		try await save(to: sut, data: anyData(), forKey: "a")
		try await save(to: sut, data: anyData(), forKey: "b")

		try await getData(from: sut, forKey: "a")

		try await save(to: sut, data: anyData(), forKey: "c")

		let a = try await getData(from: sut, forKey: "a")
		XCTAssertNotNil(a)

		let b = try await getData(from: sut, forKey: "b")
		XCTAssertNil(b)

		let c = try await getData(from: sut, forKey: "c")
		XCTAssertNotNil(c)
	}

	func test_save_evictsLeastRecentlyUsedItemsOnSizeLimitExceeded() async throws {
		let sut = makeSUT(sizeLimitInBytes: 20)

		try await save(to: sut, data: Data(repeating: 1, count: 10), forKey: "a")
		try await save(to: sut, data: Data(repeating: 1, count: 10), forKey: "b")

		try await getData(from: sut, forKey: "a")

		try await save(to: sut, data: anyData(), forKey: "c")

		let a = try await getData(from: sut, forKey: "a")
		XCTAssertNotNil(a)

		let b = try await getData(from: sut, forKey: "b")
		XCTAssertNil(b)

		let c = try await getData(from: sut, forKey: "c")
		XCTAssertNotNil(c)
	}

	func test_save_respectsCountAndSizeLimit() async throws {
		let sut = makeSUT(countLimit: 2, sizeLimitInBytes: 10)

		try await save(to: sut, data: Data(repeating: 0, count: 6), forKey: "a")
		try await save(to: sut, data: Data(repeating: 1, count: 6), forKey: "b")
		try await save(to: sut, data: Data(repeating: 2, count: 1), forKey: "c")
		try await save(to: sut, data: Data(repeating: 2, count: 1), forKey: "d")

		let a = try await getData(from: sut, forKey: "a")
		XCTAssertNil(a, "Expect a to be evicted by size limit")

		let b = try await getData(from: sut, forKey: "b")
		XCTAssertNil(b, "Expect b to be evicted by count limit")

		let c = try await getData(from: sut, forKey: "c")
		XCTAssertNotNil(c)

		let d = try await getData(from: sut, forKey: "d")
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

	private func save(to sut: ImageDataCache, data: Data, forKey key: String) async throws {
		try await sut.save(data, forKey: key)
	}

	@discardableResult
	private func getData(from sut: ImageDataCache, forKey key: String) async throws -> Data? {
		try await sut.data(forKey: key)
	}
}

func anyKey() -> String {
	"any key"
}
