//
//  DestinationSearchWorkerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/6/25.
//

import XCTest
import HotelsDemo

@MainActor
final class DestinationSearchWorkerTests: XCTestCase {
	func test_init_doesNotPerformRequest() {
		let (_, client) = makeSUT()
		
		XCTAssertTrue(client.receivedRequests().isEmpty)
	}

	func test_search_performsRequestWithCorrectURL() async throws {
		let expectedURL = URL(string: "https://api.com/search?q=london")!
		let (sut, client) = makeSUT(url: expectedURL)

		client.completeWith(anyValidValues())
		_ = try await sut.search(query: "ignored")

		XCTAssertEqual(client.receivedRequests().map(\.url), [expectedURL])
	}

	func test_search_deliversErrorOnClientError() async throws {
		let clientError = anyNSError()
		let (sut, client) = makeSUT()

		try await expect(sut, toCompleteWithError: clientError, when: {
			client.completeWithError(clientError)
		})
	}

	func test_search_deliversErrorOnNon200HTTPResponse() async throws {
		let samples = [199, 300, 350, 404, 500]
		let (sut, client) = makeSUT()

		for statusCode in samples {
			try await expect(sut, toCompleteWithError: HTTPError.unexpectedStatusCode(statusCode), when: {
				client.completeWith((anyData(), makeHTTPURLResponse(statusCode: statusCode)))
			})
		}
	}

	func test_search_deliversErrorOn200HTTPResponseWithEmptyDataOrInvalidJSON() async throws {
		let samples = [emptyData(), invalidJSONData()]
		let (sut, client) = makeSUT()

		for data in samples {
			try await expect(sut, toCompleteWithError: APIError.decoding(anyNSError()), when: {
				client.completeWith((data, makeHTTPURLResponse(statusCode: 200)))
			})
		}
	}

	func test_search_deliversResultOn200HTTPResponseWithValidJSON() async throws {
		let item = makeDestinationJSON(
			id: 929,
			type: "district",
			name: "Manhattan",
			label: "Manhattan, New York, New York State, United States",
			country: "United States",
			cityName: "New York"
		)
		let destinationsJSON = makeAPIResponseJSON(data: [item.json])
		let data = makeJSONData(destinationsJSON)
		let (sut, client) = makeSUT()

		try await expect(sut, toCompleteWithDestinations: [item.model], when: {
			client.completeWith((data, makeHTTPURLResponse(statusCode: 200)))
		})
	}

	// MARK: - Helpers

	private func makeSUT(url: URL = anyURL()) -> (
		sut: DestinationSearchWorker,
		client: HTTPClientSpy
	) {
		let client = HTTPClientSpy()
		let sut = DestinationSearchWorker(
			factory: DestinationRequestFactoryStub(url: url),
			client: client
		)
		return (sut, client)
	}

	private func expect(
		_ sut: DestinationSearchWorker,
		toCompleteWithDestinations expectedDestinations: [Destination],
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) async throws {
		action()

		let destinations = try await sut.search(query: "any")

		XCTAssertEqual(expectedDestinations, destinations)
	}

	private func expect(
		_ sut: DestinationSearchWorker,
		toCompleteWithError expectedError: Error,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) async throws {
		action()

		var receivedError: NSError?
		do {
			_ = try await sut.search(query: "any")
		} catch {
			receivedError = error as NSError
		}

		XCTAssertEqual(expectedError as NSError, receivedError, file: file, line: line)
	}

	private func anyValidValues() -> (Data, HTTPURLResponse) {
		let item = anyDestinationJSON()
		let destinationsJSON = makeAPIResponseJSON(data: [item.json])
		let data = makeJSONData(destinationsJSON)
		return (data, makeHTTPURLResponse(statusCode: 200))
	}

	private func anyDestinationJSON() -> (model: Destination, json: [String: Any]) {
		makeDestinationJSON(
			id: 1,
			type: "any type",
			name: "any name",
			label: "any label",
			country: "any country",
			cityName: "any city name"
		)
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
