//
//  HotelsSearchCriteriaInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo

final class HotelsSearchCriteriaInteractorTests: XCTestCase {
	func test_doFetchCriteria_presentLoadErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doFetchCriteria(request: .init())
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_doFetchCriteria_presentCriteriaOnProviderSuccess() {
		let criteria = anySearchCriteria()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doFetchCriteria(request: .init())
		provider.completeRetrieve(with: .success(criteria))

		XCTAssertEqual(presenter.messages, [.presentCriteria(.init(criteria: criteria))])
	}

	func test_doFetchDateRange_presentLoadErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doFetchDateRange(request: .init())
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_doFetchDateRange_presentDatesOnProviderSuccess() {
		let checkInDate = "27.06.2025".date()
		let checkOutDate = "28.06.2025".date()
		let criteria = makeSearchCriteria(checkInDate: checkInDate, checkOutDate: checkOutDate)
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.doFetchDateRange(request: .init())
		provider.completeRetrieve(with: .success(criteria))

		XCTAssertEqual(presenter.messages, [.presentDates(.init(checkInDate: checkInDate, checkOutDate: checkOutDate))])
	}

	func test_doFetchRoomGuests_presentLoadErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.doFetchRoomGuests(request: .init())
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_doFetchRoomGuests_presentRoomGuestsOnProviderSuccess() {
		let criteria = anySearchCriteria()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doFetchRoomGuests(request: .init())
		provider.completeRetrieve(with: .success(criteria))

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

	func test_doSearch_presentLoadErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doSearch(request: .init())
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_doSearch_presentSearchOnSuccess() {
		let criteria = anySearchCriteria()
		let (sut, provider, _, presenter) = makeSUT()

		sut.doSearch(request: .init())
		provider.completeRetrieve(with: .success(criteria))

		XCTAssertEqual(presenter.messages, [.presentSearch(.init(criteria: criteria))])
	}

	func test_handleDestinationSelection_presentUpdateErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.handleDestinationSelection(request: .init(destination: anyDestination()))
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentUpdateError(providerError)])
	}

	func test_handleDestinationSelection_presentUpdateErrorOnCacheError() {
		let cacheError = anyNSError()
		let (sut, provider, cache, presenter) = makeSUT()
		
		sut.handleDestinationSelection(request: .init(destination: anyDestination()))
		provider.completeRetrieve(with: .success(anySearchCriteria()))
		cache.completeSave(with: .failure(cacheError))

		XCTAssertEqual(presenter.messages, [.presentUpdateError(cacheError)])
	}

	func test_handleDestinationSelection_presentUpdateDestinationOnSucess() {
		let destination = anyDestination()
		let criteria = anySearchCriteria()
		var expectedCriteria = criteria
		expectedCriteria.destination = destination
		let (sut, provider, cache, presenter) = makeSUT()

		sut.handleDestinationSelection(request: .init(destination: destination))
		provider.completeRetrieve(with: .success(criteria))
		cache.completeSave(with: .success(()))

		XCTAssertEqual(presenter.messages, [.presentUpdateDestination(.init(criteria: expectedCriteria))])
	}

	func test_handleDateRangeSelection_presentUpdateErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.handleDateRangeSelection(request: .init(checkInDate: Date(), checkOutDate: Date()))
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentUpdateError(providerError)])
	}

	func test_handleDateRangeSelection_presentUpdateErrorOnCacheError() {
		let cacheError = anyNSError()
		let (sut, provider, cache, presenter) = makeSUT()

		sut.handleDateRangeSelection(request: .init(checkInDate: Date(), checkOutDate: Date()))
		provider.completeRetrieve(with: .success(anySearchCriteria()))
		cache.completeSave(with: .failure(cacheError))

		XCTAssertEqual(presenter.messages, [.presentUpdateError(cacheError)])
	}

	func test_handleDateRangeSelection_presentUpdateDatesOnSucess() {
		let checkInDate = "27.06.2025".date()
		let checkOutDate = "28.06.2025".date()
		let criteria = anySearchCriteria()
		var expectedCriteria = criteria
		expectedCriteria.checkInDate = checkInDate
		expectedCriteria.checkOutDate = checkOutDate
		let (sut, provider, cache, presenter) = makeSUT()

		sut.handleDateRangeSelection(request: .init(checkInDate: checkInDate, checkOutDate: checkOutDate))
		provider.completeRetrieve(with: .success(criteria))
		cache.completeSave(with: .success(()))

		XCTAssertEqual(presenter.messages, [.presentUpdateDates(.init(criteria: expectedCriteria))])
	}

	func test_handleRoomGuestsSelection_presentUpdateErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.handleRoomGuestsSelection(request: .init(rooms: 1, adults: 1, childrenAge: [0]))
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentUpdateError(providerError)])
	}

	func test_handleRoomGuestsSelection_presentUpdateErrorOnCacheError() {
		let cacheError = anyNSError()
		let (sut, provider, cache, presenter) = makeSUT()

		sut.handleRoomGuestsSelection(request: .init(rooms: 1, adults: 1, childrenAge: [0]))
		provider.completeRetrieve(with: .success(anySearchCriteria()))
		cache.completeSave(with: .failure(cacheError))

		XCTAssertEqual(presenter.messages, [.presentUpdateError(cacheError)])
	}

	func test_handleRoomGuestsSelection_presentUpdateRoomGuestsOnSuccess() {
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
		provider.completeRetrieve(with: .success(criteria))
		cache.completeSave(with: .success(()))

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

	func retrieve(completion: @escaping (HotelsSearchCriteriaProvider.RetrieveResult) -> Void) {
		completion(.success(criteria))
	}
}

final class HotelsSearchCriteriaProviderSpy: HotelsSearchCriteriaProvider {
	private var retrieveCompletions: [((RetrieveResult) -> Void)] = []

	func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		retrieveCompletions.append(completion)
	}

	func completeRetrieve(with result: RetrieveResult, at index: Int = 0) {
		retrieveCompletions[index](result)
	}
}

final class HotelsSearchCriteriaCacheSpy: HotelsSearchCriteriaCache {
	private var saveCompletions: [((SaveResult) -> Void)] = []

	func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void) {
		saveCompletions.append(completion)
	}

	func completeSave(with result: SaveResult, at index: Int = 0) {
		saveCompletions[index](result)
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

	func presentLoadCriteria(response: HotelsSearchCriteriaModels.FetchCriteria.Response) {
		messages.append(.presentCriteria(response))
	}

	func presentDates(response: HotelsSearchCriteriaModels.FetchDates.Response) {
		messages.append(.presentDates(response))
	}

	func presentRoomGuests(response: HotelsSearchCriteriaModels.FetchRoomGuests.Response) {
		messages.append(.presentRoomGuests(response))
	}
	
	func presentUpdateDestination(response: HotelsSearchCriteriaModels.DestinationSelection.Response) {
		messages.append(.presentUpdateDestination(response))
	}
	
	func presentUpdateDates(response: HotelsSearchCriteriaModels.DateRangeSelection.Response) {
		messages.append(.presentUpdateDates(response))
	}
	
	func presentUpdateRoomGuests(response: HotelsSearchCriteriaModels.RoomGuestsSelection.Response) {
		messages.append(.presentUpdateRoomGuests(response))
	}

	func presentSearch(response: HotelsSearchCriteriaModels.Search.Response) {
		messages.append(.presentSearch(response))
	}

	func presentLoadError(_ error: Error) {
		messages.append(.presentLoadError(error as NSError))
	}

	func presentUpdateError(_ error: Error) {
		messages.append(.presentUpdateError(error as NSError))
	}
}
