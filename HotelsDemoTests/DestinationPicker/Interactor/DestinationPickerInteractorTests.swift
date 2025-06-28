//
//  DestinationPickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/6/25.
//

import XCTest
import HotelsDemo

final class DestinationPickerInteractorTests: XCTestCase {
	func test_init_doesNotMessageSearchService() {
		let (_, service) = makeSUT()

		XCTAssertTrue(service.queries.isEmpty)
	}

	// MARK: - Helpers

	private func makeSUT() -> (sut: DestinationPickerInteractor, service: DestinationSearchServiceSpy) {
		let service = DestinationSearchServiceSpy()
		let sut = DestinationPickerInteractor(worker: service)
		return (sut, service)
	}
}

final class DestinationSearchServiceSpy: DestinationSearchService {
	private(set) var queries = [String]()

	private var completions = [(DestinationSearchService.Result) -> Void]()

	func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		queries.append(query)
		completions.append(completion)
	}
}
