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

	func test_search_deliversErrorOnClientError() {
		let clientError = anyNSError()
		let (sut, client) = makeSUT()

		let exp = expectation(description: "Wait for completion")

		sut.search(query: "any") { result in
			switch result {
			case .success:
				XCTFail("Expected failure, got success instead")
			case let .failure(error):
				XCTAssertEqual(error as NSError, clientError)
			}
			exp.fulfill()
		}

		client.completeWithResult(.failure(clientError))

		wait(for: [exp], timeout: 0.1)
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

	func completeWithResult(_ result: HTTPClient.Result, at index: Int = 0) {
		completions[index](result)
	}
}
