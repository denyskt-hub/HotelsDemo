//
//  LocalImageDataLoaderTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class LocalImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_init_doesNotRequestDataFromCache() {
		let (_, cache) = makeSUT()

		XCTAssertTrue(cache.receivedMessages().isEmpty)
	}

	func test_load_requestsDataFromCacheUsingURLKey() async throws {
		let url = anyURL()
		let key = url.absoluteString
		let (sut, cache) = makeSUT()
		cache.stubDataResult(.success(anyData()))

		try await sut.load(url: url)

		XCTAssertEqual(cache.receivedMessages(), [.data(key)])
	}

	func test_load_deliversErrorOnCacheError() async {
		let cacheError = anyNSError()
		let (sut, cache) = makeSUT()

		await expect(sut, toLoadWithError: cacheError, when: {
			cache.stubDataResult(.failure(cacheError))
		})
	}

	func test_load_deliversNotFoundErrorOnMissingDataFromCache() async {
		let (sut, cache) = makeSUT()

		await expect(sut, toLoadWithError: LocalImageDataLoader.Error.notFound, when: {
			cache.stubDataResult(.success(.none))
		})
	}

	func test_load_deliversDataFromStoreWhenAvailable() async {
		let data = anyData()
		let (sut, cache) = makeSUT()

		await expect(sut, toLoadData: data, when: {
			cache.stubDataResult(.success(data))
		})
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: LocalImageDataLoader,
		cache: ImageDataCacheSpy
	) {
		let cache = ImageDataCacheSpy()
		let sut = LocalImageDataLoader(cache: cache)
		return (sut, cache)
	}
}

final class ImageDataCacheSpy: ImageDataCache {
	enum Message: Equatable {
		case save(Data, String)
		case data(String)
	}

	private let messages = Mutex<[Message]>([])

	func receivedMessages() -> [Message] {
		messages.withLock { $0 }
	}

	private let saveResultStub = Mutex<SaveResult?>(nil)
	private let dataResultStub = Mutex<DataResult?>(nil)

	func save(_ data: Data, forKey key: String) async throws {
		guard let saveResultStub = saveResultStub.withLock({ $0 }) else {
			fatalError("Set a stub value using stubSaveResult before calling save(_:forKey:)")
		}

		messages.withLock { $0.append(.save(data, key)) }

		if case let .failure(error) = saveResultStub {
			throw error
		}
	}

	func data(forKey key: String) async throws -> Data? {
		guard let dataResultStub = dataResultStub.withLock({ $0 }) else {
			fatalError("Set a stub value using stubDataResult before calling data(forKey:)")
		}

		messages.withLock { $0.append(.data(key)) }

		switch dataResultStub {
		case let .success(data):
			return data
		case let .failure(error):
			throw error
		}
	}

	func stubSaveResult(_ result: SaveResult) {
		saveResultStub.withLock { $0 = result }
	}

	func stubDataResult(_ result: DataResult) {
		dataResultStub.withLock { $0 = result }
	}
}
