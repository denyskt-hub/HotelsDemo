//
//  DestinationPickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/6/25.
//

import XCTest
import HotelsDemo

final class DestinationPickerInteractorTests: XCTestCase {
	func test_init_doesNotMessageService() {
		let (_, service, _) = makeSUT()

		XCTAssertTrue(service.queries.isEmpty)
	}

	func test_doSearchDestinations_presentSearchErrorOnServiceError() {
		let serviceError = anyNSError()
		let (sut, service, presenter) = makeSUT()

		sut.doSearchDestinations(request: .init(query: "any"))
		service.completeWithResult(.failure(serviceError))

		XCTAssertEqual(presenter.messages, [.presentSearchError(serviceError)])
	}

	func test_doSearchDestinations_presentDestinationsOnServiceSuccess() {
		let destinations = [anyDestination()]
		let (sut, service, presenter) = makeSUT()

		sut.doSearchDestinations(request: .init(query: "any"))
		service.completeWithResult(.success(destinations))

		XCTAssertEqual(presenter.messages, [.presentDestinations(.init(destinations: destinations))])
	}

	func test_doSearchDestinations_doesNotMessageServiceOnEmptyQuery() {
		let (sut, service, _) = makeSUT()

		sut.doSearchDestinations(request: .init(query: ""))
		XCTAssertTrue(service.queries.isEmpty)

		sut.doSearchDestinations(request: .init(query: "  "))
		XCTAssertTrue(service.queries.isEmpty)
	}

	func test_doSearchDestinations_presentEmptyDestinationsOnEmptyQuery() {
		let (sut, _, presenter) = makeSUT()

		sut.doSearchDestinations(request: .init(query: ""))
		XCTAssertEqual(presenter.messages, [.presentDestinations(.init(destinations: []))])

		sut.doSearchDestinations(request: .init(query: "  "))
		XCTAssertEqual(presenter.messages, [
			.presentDestinations(.init(destinations: [])),
			.presentDestinations(.init(destinations: []))
		])
	}

	func test_handleDestinationSelection_presentSelectedDestination() {
		let destination = anyDestination()
		let (sut, service, presenter) = makeSUT()
		sut.doSearchDestinations(request: .init(query: "any"))
		service.completeWithResult(.success([destination]))

		sut.handleDestinationSelection(request: .init(index: 0))

		XCTAssertEqual(presenter.messages.last, .presentSelectedDestination(.init(selected: destination)))
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DestinationPickerInteractor,
		service: DestinationSearchServiceSpy,
		presenter: DestinationPickerPresenterSpy
	) {
		let service = DestinationSearchServiceSpy()
		let presenter = DestinationPickerPresenterSpy()
		let sut = DestinationPickerInteractor(
			worker: service,
			presenter: presenter
		)
		return (sut, service, presenter)
	}
}

final class DestinationSearchServiceSpy: DestinationSearchService {
	private(set) var queries = [String]()

	private var completions = [(DestinationSearchService.Result) -> Void]()

	func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		queries.append(query)
		completions.append(completion)
	}

	func completeWithResult(_ result: DestinationSearchService.Result, at index: Int = 0) {
		completions[index](result)
	}
}

final class DestinationPickerPresenterSpy: DestinationPickerPresentationLogic {
	enum Message: Equatable {
		case presentDestinations(DestinationPickerModels.Search.Response)
		case presentSelectedDestination(DestinationPickerModels.DestinationSelection.Response)
		case presentSearchError(NSError)
	}

	private(set) var messages = [Message]()

	func presentDestinations(response: DestinationPickerModels.Search.Response) {
		messages.append(.presentDestinations(response))
	}

	func presentSelectedDestination(response: DestinationPickerModels.DestinationSelection.Response) {
		messages.append(.presentSelectedDestination(response))
	}

	func presentSearchError(_ error: Error) {
		messages.append(.presentSearchError(error as NSError))
	}
}
