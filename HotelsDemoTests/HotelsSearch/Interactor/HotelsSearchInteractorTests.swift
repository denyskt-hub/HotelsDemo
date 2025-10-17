//
//  HotelsSearchInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

final class HotelsSearchInteractorTests: XCTestCase {
	func test_init_doesNotRequestSearch() {
		let (_, service, _) = makeSUT()

		XCTAssertTrue(service.messages.isEmpty)
	}

	func test_search_requestsSearchWithCorrectCriteria() {
		let criteria = anySearchCriteria()
		let (sut, service, _) = makeSUT(criteria: criteria)

		sut.handleViewDidAppear(request: .init())

		XCTAssertEqual(service.messages, [.search(criteria)])
	}

	func test_search_presentsErrorOnServiceError() {
		let serviceError = anyNSError()
		let (sut, service, presenter) = makeSUT()

		sut.handleViewDidAppear(request: .init())
		service.completeWithResult(.failure(serviceError))

		XCTAssertEqual(presenter.messages.last, .presentSearchError(serviceError))
	}

	func test_search_presentsHotelsOnServiceSuccess() {
		let hotels = [anyHotel(), anyHotel()]
		let (sut, service, presenter) = makeSUT()

		sut.handleViewDidAppear(request: .init())
		service.completeWithResult(.success(hotels))

		XCTAssertEqual(presenter.messages.last, .presentSearch(.init(hotels: hotels)))
	}

	func test_filters_presentsFilters() {
		let filters = anyHotelFilters()
		let (sut, _, presenter) = makeSUT()

		sut.doFetchFilters(request: .init())

		XCTAssertEqual(presenter.messages.last, .presentFilters(.init(filters: filters)))
	}

	func test_updateFilters_presentsUpdateFilters() {
		let filters = anyHotelFilters()
		let (sut, _, presenter) = makeSUT()

		sut.handleFilterSelection(request: .init(filters: filters))

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
			repository: DefaultHotelsRepository()
		)
		sut.presenter = presenter
		return (sut, service, presenter)
	}
}

final class HotelsSearchServiceSpy: HotelsSearchService {
	enum Message: Equatable {
		case search(HotelsSearchCriteria)
	}

	private(set) var messages = [Message]()
	private var completions = [(HotelsSearchService.Result) -> Void]()

	func search(criteria: HotelsSearchCriteria, completion: @escaping (HotelsSearchService.Result) -> Void) -> HTTPClientTask {
		messages.append(.search(criteria))
		completions.append(completion)
		return TaskStub()
	}

	func completeWithResult(_ result: HotelsSearchService.Result, at index: Int = 0) {
		completions[index](result)
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

	func presentSearch(response: HotelsSearchModels.Search.Response) {
		messages.append(.presentSearch(response))
	}

	func presentSearchLoading(_ isLoading: Bool) {
		messages.append(.presentSearchLoading(isLoading))
	}

	func presentSearchError(_ error: Error) {
		messages.append(.presentSearchError(error as NSError))
	}

	func presentFilters(response: HotelsSearchModels.FetchFilters.Response) {
		messages.append(.presentFilters(response))
	}

	func presentUpdateFilters(response: HotelsSearchModels.FilterSelection.Response) {
		messages.append(.presentUpdateFilter(response))
	}
}
