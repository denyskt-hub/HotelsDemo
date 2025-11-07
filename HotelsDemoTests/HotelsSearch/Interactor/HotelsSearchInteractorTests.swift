//
//  HotelsSearchInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class HotelsSearchInteractorTests: XCTestCase {
	func test_init_doesNotRequestSearch() {
		let (_, service, _) = makeSUT()

		XCTAssertTrue(service.receivedMessages().isEmpty)
	}

	func test_search_requestsSearchWithCorrectCriteria() async {
		let criteria = anySearchCriteria()
		let (sut, service, _) = makeSUT(criteria: criteria)

		sut.handleViewDidAppear(request: .init())
		await service.waitUntilStarted()

		XCTAssertEqual(service.receivedMessages(), [.search(criteria)])
	}

	func test_search_presentsErrorOnServiceError() async {
		let serviceError = anyNSError()
		let (sut, service, presenter) = makeSUT()

		sut.handleViewDidAppear(request: .init())

		await service.waitUntilStarted()
		service.completeWithError(serviceError)

		await presenter.waitUntilPresented(expected: 3)
		XCTAssertEqual(presenter.messages, [
			.presentSearchLoading(true),
			.presentSearchError(serviceError),
			.presentSearchLoading(false)
		])
	}

	func test_search_presentsHotelsOnServiceSuccess() async {
		let hotels = [anyHotel(), anyHotel()]
		let (sut, service, presenter) = makeSUT()

		sut.handleViewDidAppear(request: .init())

		await service.waitUntilStarted()
		service.completeWithHotels(hotels)

		await presenter.waitUntilPresented(expected: 3)
		XCTAssertEqual(presenter.messages, [
			.presentSearchLoading(true),
			.presentSearch(.init(hotels: hotels)),
			.presentSearchLoading(false)
		])
	}

	func test_filters_presentsFilters() async {
		let filters = anyHotelFilters()
		let (sut, _, presenter) = makeSUT()

		sut.doFetchFilters(request: .init())

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages.last, .presentFilters(.init(filters: filters)))
	}

	func test_updateFilters_presentsUpdateFilters() async {
		let filters = anyHotelFilters()
		let (sut, _, presenter) = makeSUT()

		sut.handleFilterSelection(request: .init(filters: filters))

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages.last, .presentUpdateFilter(.init(hotels: [])))
	}

	// MARK: - Helpers

	private func makeSUT(
		criteria: HotelsSearchCriteria = anySearchCriteria(),
		filters: HotelFilters = anyHotelFilters()
	) -> (
		sut: HotelsSearchInteractor,
		service: HotelsSearchServiceSpy,
		presenter: SearchPresentationLogicSpy
	) {
		let provider = HotelsSearchCriteriaProviderStub(criteria: criteria)
		let service = HotelsSearchServiceSpy()
		let presenter = SearchPresentationLogicSpy()
		let context = HotelsSearchContext(
			provider: provider,
			service: service
		)
		let sut = HotelsSearchInteractor(
			context: context,
			filters: filters,
			repository: DefaultHotelsRepository(),
			presenter: presenter
		)
		return (sut, service, presenter)
	}
}

final class HotelsSearchServiceSpy: HotelsSearchService {
	enum Message: Equatable {
		case search(HotelsSearchCriteria)
	}

	private let messages = Mutex<[Message]>([])
	private let continuations = Mutex<[CheckedContinuation<[Hotel], Error>]>([])

	private let stream = AsyncStream<Void>.makeStream()

	func receivedMessages() -> [Message] {
		messages.withLock { $0 }
	}

	func search(criteria: HotelsSearchCriteria) async throws -> [Hotel] {
		messages.withLock { $0.append(.search(criteria)) }
		stream.continuation.yield(())

		return try await withCheckedThrowingContinuation { continuation in
			continuations.withLock { $0.append(continuation) }
		}
	}

	func completeWithHotels(_ hotels: [Hotel], at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(returning: hotels)
	}

	func completeWithError(_ error: Error, at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(throwing: error)
	}

	func waitUntilStarted() async {
		var iterator = stream.stream.makeAsyncIterator()
		_ = await iterator.next()
	}
}

final class SearchPresentationLogicSpy: HotelsSearchPresentationLogic {
	enum Message: Equatable {
		case presentSearch(HotelsSearchModels.Search.Response)
		case presentSearchLoading(Bool)
		case presentSearchError(NSError)
		case presentFilters(HotelsSearchModels.FetchFilters.Response)
		case presentUpdateFilter(HotelsSearchModels.FilterSelection.Response)
	}

	private(set) var messages = [Message]()

	private let stream = AsyncStream<Void>.makeStream()

	func presentSearch(response: HotelsSearchModels.Search.Response) {
		messages.append(.presentSearch(response))
		stream.continuation.yield(())
	}

	func presentSearchLoading(_ isLoading: Bool) {
		messages.append(.presentSearchLoading(isLoading))
		stream.continuation.yield(())
	}

	func presentSearchError(_ error: Error) {
		messages.append(.presentSearchError(error as NSError))
		stream.continuation.yield(())
	}

	func presentFilters(response: HotelsSearchModels.FetchFilters.Response) {
		messages.append(.presentFilters(response))
		stream.continuation.yield(())
	}

	func presentUpdateFilters(response: HotelsSearchModels.FilterSelection.Response) {
		messages.append(.presentUpdateFilter(response))
		stream.continuation.yield(())
	}

	func waitUntilPresented(expected count: Int = 1) async {
		var iterator = stream.stream.makeAsyncIterator()
		for _ in 0..<count {
			_ = await iterator.next()
		}
	}
}
