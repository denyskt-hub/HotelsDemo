//
//  DestinationSearchWorkerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/6/25.
//

import XCTest
import HotelsDemo

final class DestinationSearchWorkerTests: XCTestCase {
	func test_init_doesNotPerformRequest() {
		let (_, client) = makeSUT()
		
		XCTAssertTrue(client.requests.isEmpty)
	}

	// MARK: - Helpers

	private func makeSUT(url: URL = anyURL()) -> (sut: DestinationSearchWorker, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = DestinationSearchWorker(
			url: url,
			client: client,
			dispatcher: ImmediateDispatcher()
		)
		return (sut, client)
	}
}

final class HTTPClientSpy: HTTPClient {
	private(set) var requests = [URLRequest]()

	private var completions = [(HTTPClient.Result) -> Void]()

	func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
		requests.append(request)
		completions.append(completion)
	}
}
