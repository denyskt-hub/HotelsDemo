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

		cache.completeDataWith(anyData())
		try await sut.load(url: url)

		XCTAssertEqual(cache.receivedMessages(), [.data(key)])
	}

	func test_load_deliversErrorOnCacheError() async {
		let cacheError = anyNSError()
		let (sut, cache) = makeSUT()

		await expect(sut, toLoadWithError: cacheError, when: {
			cache.completeDataWithError(cacheError)
		})
	}

	func test_load_deliversNotFoundErrorOnMissingDataFromCache() async {
		let (sut, cache) = makeSUT()

		await expect(sut, toLoadWithError: LocalImageDataLoader.Error.notFound, when: {
			cache.completeDataWith(.none)
		})
	}

	func test_load_deliversDataFromStoreWhenAvailable() async {
		let data = anyData()
		let (sut, cache) = makeSUT()

		await expect(sut, toLoadData: data, when: {
			cache.completeDataWith(data)
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

	private let saveCompletions = Mutex<[((SaveResult) -> Void)]>([])
	private let dataCompletions =  Mutex<[((DataResult) -> Void)]>([])

	func save(_ data: Data, forKey key: String, completion: @escaping (SaveResult) -> Void) {
		messages.withLock { $0.append(.save(data, key)) }

		if let saveResultStub = saveResultStub.withLock({ $0 }) {
			completion(saveResultStub)
		} else {
			saveCompletions.withLock { $0.append(completion) }
		}
	}

	func data(forKey key: String, completion: @escaping (DataResult) -> Void) {
		messages.withLock { $0.append(.data(key)) }

		if let dataResultStub = dataResultStub.withLock({ $0 }) {
			completion(dataResultStub)
		} else {
			dataCompletions.withLock { $0.append(completion) }
		}
	}

	func completeSaveWith(_ error: Error, at index: Int = 0) {
		saveCompletions.withLock({ $0 })[index](.failure(error))
	}

	func completeDataWith(_ result: DataResult, at index: Int = 0) {
		dataCompletions.withLock({ $0 })[index](result)
	}

	func completeSaveWithError(_ error: Error) {
		saveResultStub.withLock { $0 = .failure(error) }
	}

	func completeDataWith(_ data: Data?) {
		dataResultStub.withLock { $0 = .success(data) }
	}

	func completeDataWithError(_ error: Error) {
		dataResultStub.withLock { $0 = .failure(error) }
	}
}
