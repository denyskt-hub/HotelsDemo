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
	func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void) {

	}
}

final class SearchCriteriaPresenterSpy: SearchCriteriaPresentationLogic {
	enum Message: Equatable {
		case presentCriteria(SearchCriteriaModels.Load.Response)
		case presentLoadError(NSError)
	}

	private(set) var messages = [Message]()

	func presentCriteria(response: SearchCriteriaModels.Load.Response) {
		messages.append(.presentCriteria(response))
	}
	
	func presentLoadError(_ error: Error) {
		messages.append(.presentLoadError(error as NSError))
	}
	
	func presentRoomGuests(response: SearchCriteriaModels.LoadRoomGuests.Response) {

	}
	
	func presentDates(response: SearchCriteriaModels.LoadDates.Response) {

	}
	
	func presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response) {

	}
	
	func presentCriteria(response: SearchCriteriaModels.UpdateDates.Response) {

	}
	
	func presentCriteria(response: SearchCriteriaModels.UpdateRoomGuests.Response) {

	}
	
	func presentUpdateError(_ error: Error) {

	}
}
