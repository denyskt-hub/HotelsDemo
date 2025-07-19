//
//  HotelsSearchCriteriaInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo

final class HotelsSearchCriteriaInteractorTests: XCTestCase {
	func test_loadCriteria_presentLoadErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.loadCriteria(request: .init())
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_loadCriteria_presentCriteriaOnProviderSuccess() {
		let criteria = anySearchCriteria()
		let (sut, provider, _, presenter) = makeSUT()

		sut.loadCriteria(request: .init())
		provider.completeRetrieve(with: .success(criteria))

		XCTAssertEqual(presenter.messages, [.presentCriteria(.init(criteria: criteria))])
	}

	func test_loadDates_presentLoadErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.loadDates(request: .init())
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_loadDates_presentDatesOnProviderSuccess() {
		let checkInDate = "27.06.2025".date()
		let checkOutDate = "28.06.2025".date()
		let criteria = makeSearchCriteria(checkInDate: checkInDate, checkOutDate: checkOutDate)
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.loadDates(request: .init())
		provider.completeRetrieve(with: .success(criteria))

		XCTAssertEqual(presenter.messages, [.presentDates(.init(checkInDate: checkInDate, checkOutDate: checkOutDate))])
	}

	func test_loadRoomGuests_presentLoadErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.loadRoomGuests(request: .init())
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_loadRoomGuests_presentRoomGuestsOnProviderSuccess() {
		let criteria = anySearchCriteria()
		let (sut, provider, _, presenter) = makeSUT()

		sut.loadRoomGuests(request: .init())
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

	func test_updateDestination_presentUpdateErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()

		sut.updateDestination(request: .init(destination: anyDestination()))
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentUpdateError(providerError)])
	}

	func test_updateDestination_presentUpdateErrorOnCacheError() {
		let cacheError = anyNSError()
		let (sut, provider, cache, presenter) = makeSUT()
		
		sut.updateDestination(request: .init(destination: anyDestination()))
		provider.completeRetrieve(with: .success(anySearchCriteria()))
		cache.completeSave(with: cacheError)

		XCTAssertEqual(presenter.messages, [.presentUpdateError(cacheError)])
	}

	func test_updateDestination_presentUpdateDestinationOnSucess() {
		let destination = anyDestination()
		let criteria = anySearchCriteria()
		var expectedCriteria = criteria
		expectedCriteria.destination = destination
		let (sut, provider, cache, presenter) = makeSUT()

		sut.updateDestination(request: .init(destination: destination))
		provider.completeRetrieve(with: .success(criteria))
		cache.completeSave(with: .none)

		XCTAssertEqual(presenter.messages, [.presentUpdateDestination(.init(criteria: expectedCriteria))])
	}

	func test_updateDates_presentUpdateErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.updateDates(request: .init(checkInDate: Date(), checkOutDate: Date()))
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentUpdateError(providerError)])
	}

	func test_updateDates_presentUpdateErrorOnCacheError() {
		let cacheError = anyNSError()
		let (sut, provider, cache, presenter) = makeSUT()

		sut.updateDates(request: .init(checkInDate: Date(), checkOutDate: Date()))
		provider.completeRetrieve(with: .success(anySearchCriteria()))
		cache.completeSave(with: cacheError)

		XCTAssertEqual(presenter.messages, [.presentUpdateError(cacheError)])
	}

	func test_updateDates_presentUpdateDatesOnSucess() {
		let checkInDate = "27.06.2025".date()
		let checkOutDate = "28.06.2025".date()
		let criteria = anySearchCriteria()
		var expectedCriteria = criteria
		expectedCriteria.checkInDate = checkInDate
		expectedCriteria.checkOutDate = checkOutDate
		let (sut, provider, cache, presenter) = makeSUT()

		sut.updateDates(request: .init(checkInDate: checkInDate, checkOutDate: checkOutDate))
		provider.completeRetrieve(with: .success(criteria))
		cache.completeSave(with: .none)

		XCTAssertEqual(presenter.messages, [.presentUpdateDates(.init(criteria: expectedCriteria))])
	}

	func test_updateRoomGuests_presentUpdateErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.updateRoomGuests(request: .init(rooms: 1, adults: 1, childrenAge: [0]))
		provider.completeRetrieve(with: .failure(providerError))

		XCTAssertEqual(presenter.messages, [.presentUpdateError(providerError)])
	}

	func test_updateRoomGuests_presentUpdateErrorOnCacheError() {
		let cacheError = anyNSError()
		let (sut, provider, cache, presenter) = makeSUT()

		sut.updateRoomGuests(request: .init(rooms: 1, adults: 1, childrenAge: [0]))
		provider.completeRetrieve(with: .success(anySearchCriteria()))
		cache.completeSave(with: cacheError)

		XCTAssertEqual(presenter.messages, [.presentUpdateError(cacheError)])
	}

	func test_updateRoomGuests_presentUpdateRoomGuestsOnSuccess() {
		let rooms = 2
		let adults = 2
		let childrenAge = [1]
		let criteria = anySearchCriteria()
		var expectedCriteria = criteria
		expectedCriteria.roomsQuantity = rooms
		expectedCriteria.adults = adults
		expectedCriteria.childrenAge = childrenAge
		let (sut, provider, cache, presenter) = makeSUT()
		
		sut.updateRoomGuests(request: .init(rooms: rooms, adults: adults, childrenAge: childrenAge))
		provider.completeRetrieve(with: .success(criteria))
		cache.completeSave(with: .none)

		XCTAssertEqual(presenter.messages, [.presentUpdateRoomGuests(.init(criteria: expectedCriteria))])
	}

	func test_search_presentLoadErrorOnProviderError() {
		let providerError = anyNSError()
		let (sut, provider, _, presenter) = makeSUT()
		
		sut.search(request: .init())
		provider.completeRetrieve(with: .failure(providerError))
		
		XCTAssertEqual(presenter.messages, [.presentLoadError(providerError)])
	}

	func test_search_presentSearchOnSuccess() {
		let criteria = anySearchCriteria()
		let (sut, provider, _, presenter) = makeSUT()

		sut.search(request: .init())
		provider.completeRetrieve(with: .success(criteria))

		XCTAssertEqual(presenter.messages, [.presentSearch(.init(criteria: criteria))])
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
			provider: provider,
			cache: cache
		)
		sut.presenter = presenter
		return (sut, provider, cache, presenter)
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
		case presentCriteria(HotelsSearchCriteriaModels.Load.Response)
		case presentLoadError(NSError)
		case presentDates(HotelsSearchCriteriaModels.LoadDates.Response)
		case presentRoomGuests(HotelsSearchCriteriaModels.LoadRoomGuests.Response)
		case presentUpdateDestination(HotelsSearchCriteriaModels.UpdateDestination.Response)
		case presentUpdateDates(HotelsSearchCriteriaModels.UpdateDates.Response)
		case presentUpdateRoomGuests(HotelsSearchCriteriaModels.UpdateRoomGuests.Response)
		case presentUpdateError(NSError)
		case presentSearch(HotelsSearchCriteriaModels.Search.Response)
	}

	private(set) var messages = [Message]()

	func presentLoadCriteria(response: HotelsSearchCriteriaModels.Load.Response) {
		messages.append(.presentCriteria(response))
	}

	func presentDates(response: HotelsSearchCriteriaModels.LoadDates.Response) {
		messages.append(.presentDates(response))
	}

	func presentRoomGuests(response: HotelsSearchCriteriaModels.LoadRoomGuests.Response) {
		messages.append(.presentRoomGuests(response))
	}
	
	func presentUpdateDestination(response: HotelsSearchCriteriaModels.UpdateDestination.Response) {
		messages.append(.presentUpdateDestination(response))
	}
	
	func presentUpdateDates(response: HotelsSearchCriteriaModels.UpdateDates.Response) {
		messages.append(.presentUpdateDates(response))
	}
	
	func presentUpdateRoomGuests(response: HotelsSearchCriteriaModels.UpdateRoomGuests.Response) {
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
