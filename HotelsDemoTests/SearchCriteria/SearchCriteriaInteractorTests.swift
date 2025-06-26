//
//  SearchCriteriaInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo

final class SearchCriteriaInteractorTests: XCTestCase {
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

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: SearchCriteriaInteractor,
		provider: SearchCriteriaProviderSpy,
		cache: SearchCriteriaCacheSpy,
		presenter: SearchCriteriaPresenterSpy
	) {
		let provider = SearchCriteriaProviderSpy()
		let cache = SearchCriteriaCacheSpy()
		let presenter = SearchCriteriaPresenterSpy()
		let sut = SearchCriteriaInteractor(
			provider: provider,
			cache: cache
		)
		sut.presenter = presenter
		return (sut, provider, cache, presenter)
	}

	private func anyDestination() -> Destination {
		Destination(
			id: 1,
			type: "country",
			name: "any",
			label: "any label",
			country: "any",
			cityName: "any"
		)
	}
}

final class SearchCriteriaProviderSpy: SearchCriteriaProvider {
	private var retrieveCompletions: [((RetrieveResult) -> Void)] = []

	func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		retrieveCompletions.append(completion)
	}

	func completeRetrieve(with result: RetrieveResult, at index: Int = 0) {
		retrieveCompletions[index](result)
	}
}

final class SearchCriteriaCacheSpy: SearchCriteriaCache {
	private var saveCompletions: [((SaveResult) -> Void)] = []

	func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void) {
		saveCompletions.append(completion)
	}

	func completeSave(with result: SaveResult, at index: Int = 0) {
		saveCompletions[index](result)
	}
}

final class SearchCriteriaPresenterSpy: SearchCriteriaPresentationLogic {
	enum Message: Equatable {
		case presentCriteria(SearchCriteriaModels.Load.Response)
		case presentLoadError(NSError)
		case presentDates(SearchCriteriaModels.LoadDates.Response)
		case presentRoomGuests(SearchCriteriaModels.LoadRoomGuests.Response)
		case presentUpdateDestination(SearchCriteriaModels.UpdateDestination.Response)
		case presentUpdateError(NSError)
	}

	private(set) var messages = [Message]()

	func presentCriteria(response: SearchCriteriaModels.Load.Response) {
		messages.append(.presentCriteria(response))
	}
	
	func presentLoadError(_ error: Error) {
		messages.append(.presentLoadError(error as NSError))
	}

	func presentDates(response: SearchCriteriaModels.LoadDates.Response) {
		messages.append(.presentDates(response))
	}

	func presentRoomGuests(response: SearchCriteriaModels.LoadRoomGuests.Response) {
		messages.append(.presentRoomGuests(response))
	}
	
	func presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response) {
		messages.append(.presentUpdateDestination(response))
	}
	
	func presentCriteria(response: SearchCriteriaModels.UpdateDates.Response) {

	}
	
	func presentCriteria(response: SearchCriteriaModels.UpdateRoomGuests.Response) {

	}
	
	func presentUpdateError(_ error: Error) {
		messages.append(.presentUpdateError(error as NSError))
	}
}
