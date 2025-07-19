//
//  SearchInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

final class SearchInteractorTests: XCTestCase {
	func test_init_doesNotRequestSearch() {
		let (_, service, _) = makeSUT()

		XCTAssertTrue(service.messages.isEmpty)
	}

	func test_search_requestsSearchWithCorrectCriteria() {
		let criteria = anySearchCriteria()
		let (sut, service, _) = makeSUT(criteria: criteria)

		sut.search(request: .init())

		XCTAssertEqual(service.messages, [.search(criteria)])
	}

	func test_search_presentsErrorOnServiceError() {
		let serviceError = anyNSError()
		let (sut, service, presenter) = makeSUT()

		sut.search(request: .init())
		service.completeWithResult(.failure(serviceError))

		XCTAssertEqual(presenter.messages, [.presentSearchError(serviceError)])
	}

	func test_search_presentsHotelsOnServiceSuccess() {
		let hotels = [anyHotel(), anyHotel()]
		let (sut, service, presenter) = makeSUT()

		sut.search(request: .init())
		service.completeWithResult(.success(hotels))

		XCTAssertEqual(presenter.messages, [.presentSearch(.init(hotels: hotels))])
	}

	// MARK: - Helpers

	private func makeSUT(criteria: HotelsSearchCriteria = anySearchCriteria()) -> (
		sut: HotelsSearchInteractor,
		service: HotelsSearchServiceSpy,
		presenter: SearchPresentationLogicSpy
	) {
		let service = HotelsSearchServiceSpy()
		let presenter = SearchPresentationLogicSpy()
		let sut = HotelsSearchInteractor(
			criteria: criteria,
			worker: service
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

	func search(criteria: HotelsSearchCriteria, completion: @escaping (HotelsSearchService.Result) -> Void) {
		messages.append(.search(criteria))
		completions.append(completion)
	}

	func completeWithResult(_ result: HotelsSearchService.Result, at index: Int = 0) {
		completions[index](result)
	}
}

final class SearchPresentationLogicSpy: HotelsSearchPresentationLogic {
	enum Message: Equatable {
		case presentSearch(HotelsSearchModels.Search.Response)
		case presentSearchError(NSError)
	}

	private(set) var messages = [Message]()

	func presentSearch(response: HotelsSearchModels.Search.Response) {
		messages.append(.presentSearch(response))
	}
	
	func presentSearchError(_ error: Error) {
		messages.append(.presentSearchError(error as NSError))
	}
}
