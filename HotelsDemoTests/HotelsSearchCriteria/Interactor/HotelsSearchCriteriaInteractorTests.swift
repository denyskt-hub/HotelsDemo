//
//  HotelsSearchCriteriaInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class HotelsSearchCriteriaInteractorTests: XCTestCase {
	func test_doFetchCriteria_presentLoadErrorOnProviderError() async {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doFetchCriteria(request: .init())
		await provider.waitUntilStarted()
		provider.completeWithError(providerError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_doFetchCriteria_presentCriteriaOnProviderSuccess() async {
		let criteria = anySearchCriteria()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doFetchCriteria(request: .init())
		await provider.waitUntilStarted()
		provider.completeWithCriteria(criteria)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentCriteria(.init(criteria: criteria))])
	}

	func test_doFetchDateRange_presentLoadErrorOnProviderError() async {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doFetchDateRange(request: .init())
		await provider.waitUntilStarted()
		provider.completeWithError(providerError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_doFetchDateRange_presentDatesOnProviderSuccess() async {
		let checkInDate = "27.06.2025".date()
		let checkOutDate = "28.06.2025".date()
		let criteria = makeSearchCriteria(checkInDate: checkInDate, checkOutDate: checkOutDate)
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.doFetchDateRange(request: .init())
		await provider.waitUntilStarted()
		provider.completeWithCriteria(criteria)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentDates(.init(checkInDate: checkInDate, checkOutDate: checkOutDate))])
	}

	func test_doFetchRoomGuests_presentLoadErrorOnProviderError() async {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.doFetchRoomGuests(request: .init())
		await provider.waitUntilStarted()
		provider.completeWithError(providerError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_doFetchRoomGuests_presentRoomGuestsOnProviderSuccess() async {
		let criteria = anySearchCriteria()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doFetchRoomGuests(request: .init())
		await provider.waitUntilStarted()
		provider.completeWithCriteria(criteria)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [
			.presentRoomGuests(
				.init(roomGuests: .init(
					rooms: criteria.roomsQuantity,
					adults: criteria.adults,
					childrenAge: criteria.childrenAge
				))
			)
		])
	}

	func test_doSearch_presentLoadErrorOnProviderError() async {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doSearch(request: .init())
		await provider.waitUntilStarted()
		provider.completeWithError(providerError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_doSearch_presentSearchOnSuccess() async {
		let criteria = anySearchCriteria()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doSearch(request: .init())
		await provider.waitUntilStarted()
		provider.completeWithCriteria(criteria)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentSearch(.init(criteria: criteria))])
	}

	func test_handleDestinationSelection_presentUpdateErrorOnProviderError() async {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.handleDestinationSelection(request: .init(destination: anyDestination()))
		await provider.waitUntilStarted()
		provider.completeWithError(providerError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentUpdateError(providerError)])
	}

	func test_handleDestinationSelection_presentUpdateErrorOnCacheError() async {
		let cacheError = anyNSError()
		let (sut, provider, cache, presenter) = makeSUT()
		
		sut.handleDestinationSelection(request: .init(destination: anyDestination()))
		await provider.waitUntilStarted()
		provider.completeWithCriteria(anySearchCriteria())
		await cache.waitUntilStarted()
		cache.completeSaveWithError(cacheError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentUpdateError(cacheError)])
	}

	func test_handleDestinationSelection_presentUpdateDestinationOnSucess() async {
		let destination = anyDestination()
		let criteria = anySearchCriteria()
		var expectedCriteria = criteria
		expectedCriteria.destination = destination
		let (sut, provider, cache, presenter) = makeSUT()

		sut.handleDestinationSelection(request: .init(destination: destination))
		await provider.waitUntilStarted()
		provider.completeWithCriteria(criteria)
		await cache.waitUntilStarted()
		cache.completeSave()

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentUpdateDestination(.init(criteria: expectedCriteria))])
	}

	func test_handleDateRangeSelection_presentUpdateErrorOnProviderError() async {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.handleDateRangeSelection(request: .init(checkInDate: Date(), checkOutDate: Date()))
		await provider.waitUntilStarted()
		provider.completeWithError(providerError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentUpdateError(providerError)])
	}

	func test_handleDateRangeSelection_presentUpdateErrorOnCacheError() async {
		let cacheError = anyNSError()
		let (sut, provider, cache, presenter) = makeSUT()

		sut.handleDateRangeSelection(request: .init(checkInDate: Date(), checkOutDate: Date()))
		await provider.waitUntilStarted()
		provider.completeWithCriteria(anySearchCriteria())
		await cache.waitUntilStarted()
		cache.completeSaveWithError(cacheError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentUpdateError(cacheError)])
	}

	func test_handleDateRangeSelection_presentUpdateDatesOnSucess() async {
		let checkInDate = "27.06.2025".date()
		let checkOutDate = "28.06.2025".date()
		let criteria = anySearchCriteria()
		var expectedCriteria = criteria
		expectedCriteria.checkInDate = checkInDate
		expectedCriteria.checkOutDate = checkOutDate
		let (sut, provider, cache, presenter) = makeSUT()

		sut.handleDateRangeSelection(request: .init(checkInDate: checkInDate, checkOutDate: checkOutDate))
		await provider.waitUntilStarted()
		provider.completeWithCriteria(criteria)
		await cache.waitUntilStarted()
		cache.completeSave()

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentUpdateDates(.init(criteria: expectedCriteria))])
	}

	func test_handleRoomGuestsSelection_presentUpdateErrorOnProviderError() async {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.handleRoomGuestsSelection(request: .init(rooms: 1, adults: 1, childrenAge: [0]))
		await provider.waitUntilStarted()
		provider.completeWithError(providerError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentUpdateError(providerError)])
	}

	func test_handleRoomGuestsSelection_presentUpdateErrorOnCacheError() async {
		let cacheError = anyNSError()
		let (sut, provider, cache, presenter) = makeSUT()

		sut.handleRoomGuestsSelection(request: .init(rooms: 1, adults: 1, childrenAge: [0]))
		await provider.waitUntilStarted()
		provider.completeWithCriteria(anySearchCriteria())
		await cache.waitUntilStarted()
		cache.completeSaveWithError(cacheError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentUpdateError(cacheError)])
	}

	func test_handleRoomGuestsSelection_presentUpdateRoomGuestsOnSuccess() async {
		let rooms = 2
		let adults = 2
		let childrenAge = [1]
		let criteria = anySearchCriteria()
		var expectedCriteria = criteria
		expectedCriteria.roomsQuantity = rooms
		expectedCriteria.adults = adults
		expectedCriteria.childrenAge = childrenAge
		let (sut, provider, cache, presenter) = makeSUT()
		
		sut.handleRoomGuestsSelection(request: .init(rooms: rooms, adults: adults, childrenAge: childrenAge))
		await provider.waitUntilStarted()
		provider.completeWithCriteria(criteria)
		await cache.waitUntilStarted()
		cache.completeSave()

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentUpdateRoomGuests(.init(criteria: expectedCriteria))])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: HotelsSearchCriteriaInteractor,
		provider: HotelsSearchCriteriaProviderSpy,
		cache: HotelsSearchCriteriaCacheSpy,
		presenter: HotelsSearchCriteriaPresenterSpy
	) {
		let provider = HotelsSearchCriteriaProviderSpy()
		let cache = HotelsSearchCriteriaCacheSpy()
		let presenter = HotelsSearchCriteriaPresenterSpy()
		let sut = HotelsSearchCriteriaInteractor(
			cache: cache,
			provider: provider,
			presenter: presenter
		)
		return (sut, provider, cache, presenter)
	}
}

final class HotelsSearchCriteriaProviderStub: HotelsSearchCriteriaProvider {
	let criteria: HotelsSearchCriteria

	init(criteria: HotelsSearchCriteria) {
		self.criteria = criteria
	}

	func retrieve() async throws -> HotelsSearchCriteria {
		criteria
	}
}

final class HotelsSearchCriteriaProviderSpy: HotelsSearchCriteriaProvider {
	private let continuations = Mutex<[CheckedContinuation<HotelsSearchCriteria, Error>]>([])

	private let stream = AsyncStream<Void>.makeStream()

	func retrieve() async throws -> HotelsSearchCriteria {
		try await withCheckedThrowingContinuation { continuation in
			continuations.withLock { $0.append(continuation) }
			stream.continuation.yield(())
		}
	}

	func completeWithCriteria(_ criteria: HotelsSearchCriteria, at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(returning: criteria)
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

final class HotelsSearchCriteriaCacheSpy: HotelsSearchCriteriaCache {
	private let saveCompletions = Mutex<[((SaveResult) -> Void)]>([])
	private let continuations = Mutex<[CheckedContinuation<Void, Error>]>([])

	private let stream = AsyncStream<Void>.makeStream()

	func save(_ criteria: HotelsSearchCriteria, completion: @Sendable @escaping (SaveResult) -> Void) {
		saveCompletions.withLock { $0.append(completion) }
		stream.continuation.yield(())
	}

	func save(_ criteria: HotelsSearchCriteria) async throws {
		try await withCheckedThrowingContinuation { continuation in
			continuations.withLock { $0.append(continuation) }
			stream.continuation.yield(())
		}
	}

	func completeSave(at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(returning: ())
	}

	func completeSaveWithError(_ error: Error, at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(throwing: error)
	}

	func completeSave(with result: SaveResult, at index: Int = 0) {
		saveCompletions.withLock({ $0 })[index](result)
	}

	func waitUntilStarted() async {
		var iterator = stream.stream.makeAsyncIterator()
		_ = await iterator.next()
	}
}

final class HotelsSearchCriteriaPresenterSpy: HotelsSearchCriteriaPresentationLogic {
	enum Message: Equatable {
		case presentCriteria(HotelsSearchCriteriaModels.FetchCriteria.Response)
		case presentLoadError(NSError)
		case presentDates(HotelsSearchCriteriaModels.FetchDates.Response)
		case presentRoomGuests(HotelsSearchCriteriaModels.FetchRoomGuests.Response)
		case presentUpdateDestination(HotelsSearchCriteriaModels.DestinationSelection.Response)
		case presentUpdateDates(HotelsSearchCriteriaModels.DateRangeSelection.Response)
		case presentUpdateRoomGuests(HotelsSearchCriteriaModels.RoomGuestsSelection.Response)
		case presentUpdateError(NSError)
		case presentSearch(HotelsSearchCriteriaModels.Search.Response)
	}

	private(set) var messages = [Message]()

	private let stream = AsyncStream<Void>.makeStream()

	func presentLoadCriteria(response: HotelsSearchCriteriaModels.FetchCriteria.Response) {
		messages.append(.presentCriteria(response))
		stream.continuation.yield(())
	}

	func presentDates(response: HotelsSearchCriteriaModels.FetchDates.Response) {
		messages.append(.presentDates(response))
		stream.continuation.yield(())
	}

	func presentRoomGuests(response: HotelsSearchCriteriaModels.FetchRoomGuests.Response) {
		messages.append(.presentRoomGuests(response))
		stream.continuation.yield(())
	}
	
	func presentUpdateDestination(response: HotelsSearchCriteriaModels.DestinationSelection.Response) {
		messages.append(.presentUpdateDestination(response))
		stream.continuation.yield(())
	}
	
	func presentUpdateDates(response: HotelsSearchCriteriaModels.DateRangeSelection.Response) {
		messages.append(.presentUpdateDates(response))
		stream.continuation.yield(())
	}
	
	func presentUpdateRoomGuests(response: HotelsSearchCriteriaModels.RoomGuestsSelection.Response) {
		messages.append(.presentUpdateRoomGuests(response))
		stream.continuation.yield(())
	}

	func presentSearch(response: HotelsSearchCriteriaModels.Search.Response) {
		messages.append(.presentSearch(response))
		stream.continuation.yield(())
	}

	func presentLoadError(_ error: Error) {
		messages.append(.presentLoadError(error as NSError))
		stream.continuation.yield(())
	}

	func presentUpdateError(_ error: Error) {
		messages.append(.presentUpdateError(error as NSError))
		stream.continuation.yield(())
	}

	func waitUntilPresented() async {
		var iterator = stream.stream.makeAsyncIterator()
		_ = await iterator.next()
	}
}
