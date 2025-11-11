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

	func test_load_requestsDataFromCacheUsingURLKey() {
		let url = anyURL()
		let key = url.absoluteString
		let (sut, cache) = makeSUT()

		sut.load(url: url) { _ in }

		XCTAssertEqual(cache.receivedMessages(), [.data(key)])
	}

	func test_load_deliversErrorOnCacheError() {
		let cacheError = anyNSError()
		let (sut, cache) = makeSUT()

		expect(sut, toLoad: .failure(cacheError), when: {
			cache.completeDataWith(.failure(cacheError))
		})
	}

	func test_load_deliversNotFoundErrorOnMissingDataFromCache() async throws {
		let (sut, cache) = makeSUT()

		expect(sut, toLoad: .failure(LocalImageDataLoader.Error.notFound), when: {
			cache.completeDataWith(.success(.none))
		})
	}

	func test_load_deliversDataFromStoreWhenAvailable() async throws {
		let data = anyData()
		let (sut, cache) = makeSUT()

		expect(sut, toLoad: .success(data), when: {
			cache.completeDataWith(.success(data))
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

	private let saveCompletions = Mutex<[((SaveResult) -> Void)]>([])
	private let dataCompletions =  Mutex<[((DataResult) -> Void)]>([])

	func save(_ data: Data, forKey key: String, completion: @escaping (SaveResult) -> Void) {
		messages.withLock { $0.append(.save(data, key)) }
		saveCompletions.withLock { $0.append(completion) }
	}
	
	func data(forKey key: String, completion: @escaping (DataResult) -> Void) {
		messages.withLock { $0.append(.data(key)) }
		dataCompletions.withLock { $0.append(completion) }
	}

	func completeSaveWith(_ error: Error, at index: Int = 0) {
		saveCompletions.withLock({ $0 })[index](.failure(error))
	}

	func completeDataWith(_ result: DataResult, at index: Int = 0) {
		dataCompletions.withLock({ $0 })[index](result)
	}
}
