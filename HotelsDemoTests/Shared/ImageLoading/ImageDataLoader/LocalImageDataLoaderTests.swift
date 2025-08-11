//
//  LocalImageDataLoaderTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

final class LocalImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_init_doesNotRequestDataFromCache() {
		let (_, cache) = makeSUT()

		XCTAssertTrue(cache.messages.isEmpty)
	}

	func test_load_requestsDataFromCacheUsingURLKey() {
		let url = anyURL()
		let key = url.absoluteString
		let (sut, cache) = makeSUT()

		sut.load(url: url) { _ in }

		XCTAssertEqual(cache.messages, [.data(key)])
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
		let sut = LocalImageDataLoader(
			cache: cache,
			dispatcher: ImmediateDispatcher()
		)
		return (sut, cache)
	}
}

final class ImageDataCacheSpy: ImageDataCache {
	enum Message: Equatable {
		case save(Data, String)
		case data(String)
	}

	private(set) var messages = [Message]()

	private var saveCompletions = [(SaveResult) -> Void]()
	private var dataCompletions = [(DataResult) -> Void]()

	func save(_ data: Data, forKey key: String, completion: @escaping (SaveResult) -> Void) {
		messages.append(.save(data, key))
		saveCompletions.append(completion)
	}
	
	func data(forKey key: String, completion: @escaping (DataResult) -> Void) {
		messages.append(.data(key))
		dataCompletions.append(completion)
	}

	func completeSaveWith(_ error: Error, at index: Int = 0) {
		saveCompletions[index](.failure(error))
	}

	func completeDataWith(_ result: DataResult, at index: Int = 0) {
		dataCompletions[index](result)
	}
}
