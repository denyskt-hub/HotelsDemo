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

		expect(sut, toCompleteWith: .failure(clientError), when: {
			client.completeWithResult(.failure(clientError))
		})
	}

	func test_search_deliversErrorOnNon200HTTPResponse() {
		let samples = [199, 300, 350, 404, 500]
		let (sut, client) = makeSUT()

		for (index, statusCode) in samples.enumerated() {
			expect(sut, toCompleteWith: .failure(HTTPError.unexpectedStatusCode(statusCode)), when: {
				client.completeWithResult(.success((anyData(), makeHTTPURLResponse(statusCode: statusCode))), at: index)
			})
		}
	}

	func test_search_deliversErrorOn200HTTPResponseWithEmptyDataOrInvalidJSON() {
		let emptyData = Data()
		let invalidJSONData = Data("inalid json".utf8)
		let samples = [emptyData, invalidJSONData]
		let (sut, client) = makeSUT()

		for (index, data) in samples.enumerated() {
			expect(sut, toCompleteWith: .failure(APIError.decoding), when: {
				client.completeWithResult(.success((data, makeHTTPURLResponse(statusCode: 200))), at: index)
			})
		}
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

	private func expect(
		_ sut: DestinationSearchWorker,
		toCompleteWith expectedResult: DestinationSearchService.Result,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let exp = expectation(description: "Wait for completion")

		sut.search(query: "any") { receivedResult in
			switch (receivedResult, expectedResult) {
			case let (.success(received), .success(expected)):
				XCTAssertEqual(received, expected, file: file, line: line)
			case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
				XCTAssertEqual(receivedError, expectedError, file: file, line: line)
			default:
				XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
			}
			exp.fulfill()
		}

		action()

		wait(for: [exp], timeout: 0.1)
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
