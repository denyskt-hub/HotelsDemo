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

	func test_search_deliversResultOn200HTTPResponseWithValidJSON() throws {
		let item1 = makeDestinationJSON(
			id: 929,
			type: "district",
			name: "Manhattan",
			label: "Manhattan, New York, New York State, United States",
			country: "United States",
			cityName: "New York"
		)
		let item2 = makeDestinationJSON(
			id: 20079942,
			type: "city",
			name: "Manchester",
			label: "Manchester, New Hampshire, United States",
			country: "United States",
			cityName: "Manchester"
		)
		let destinationsJSON = makeAPIResponseJSON(data: [item1.json, item2.json])
		let data = makeJSONData(destinationsJSON)
		let (sut, client) = makeSUT()

		expect(sut, toCompleteWith: .success([item1.model, item2.model]), when: {
			client.completeWithResult(.success((data, makeHTTPURLResponse(statusCode: 200))))
		})
	}

	// MARK: - Helpers

	private func makeSUT(url: URL = anyURL()) -> (sut: DestinationSearchWorker, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = DestinationSearchWorker(
			factory: DestinationRequestFactoryStub(url: url),
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

	private func makeDestinationJSON(
		id: Int,
		type: String,
		name: String,
		label: String,
		country: String,
		cityName: String
	) -> (model: Destination, json: [String: Any]) {
		let model = Destination(
			id: id,
			type: type,
			name: name,
			label: label,
			country: country,
			cityName: cityName
		)

		let json = [
			"dest_id": "\(id)",
			"dest_type": type,
			"name": name,
			"label": label,
			"country": country,
			"city_name": cityName
		] as [String: Any]

		return (model, json)
	}

	private func makeAPIResponseJSON(
		status: Bool = true,
		message: String = "success",
		data: [[String: Any]]
	) -> [String: Any] {
		[
			"status": status,
			"message": message,
			"data": data
		]
	}

	private func makeJSONData(_ json: [String: Any]) -> Data {
		try! JSONSerialization.data(withJSONObject: json)
	}
}

final class DestinationRequestFactoryStub: DestinationsRequestFactory {
	let url: URL

	init(url: URL) {
		self.url = url
	}

	func makeSearchRequest(query: String) -> URLRequest {
		URLRequest(url: url)
	}
}
