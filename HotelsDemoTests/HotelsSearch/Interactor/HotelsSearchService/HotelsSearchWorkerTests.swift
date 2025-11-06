//
//  HotelsSearchWorkerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

@MainActor
final class HotelsSearchWorkerTests: XCTestCase {
	func test_init_doesNotPerformRequest() {
		let (_, client) = makeSUT()

		XCTAssertTrue(client.receivedRequests().isEmpty)
	}

	func test_search_performsRequestWithCorrectURL() {
		let expectedURL = URL(string: "https://api.com/hotels/search")!
		let (sut, client) = makeSUT(url: expectedURL)

		client.completeWith(anyValidValues())
		sut.search(criteria: anySearchCriteria()) { _ in }

		XCTAssertEqual(client.receivedRequests().map(\.url), [expectedURL])
	}

	func test_search_deliversErrorOnClientError() {
		let clientError = anyNSError()
		let (sut, client) = makeSUT()

		expect(sut, toCompleteWith: .failure(clientError), when: {
			client.completeWithError(clientError)
		})
	}

	func test_search_deliversErrorOnNon200HTTPResponse() {
		let samples = [199, 300, 350, 404, 500]
		let (sut, client) = makeSUT()

		for statusCode in samples {
			expect(sut, toCompleteWith: .failure(HTTPError.unexpectedStatusCode(statusCode)), when: {
				client.completeWith((anyData(), makeHTTPURLResponse(statusCode: statusCode)))
			})
		}
	}

	func test_search_deliversErrorOn200HTTPResponseWithEmptyDataOrInvalidJSON() {
		let samples = [emptyData(), invalidJSONData()]
		let (sut, client) = makeSUT()

		for data in samples {
			expect(sut, toCompleteWith: .failure(APIError.decoding(anyNSError())), when: {
				client.completeWith((data, makeHTTPURLResponse(statusCode: 200)))
			})
		}
	}

	func test_search_deliversResultOn200HTTPResponseWithValidJSON() throws {
		let item = makeHotelJSON(
			id: 1,
			position: 0,
			name: "Hotel",
			starRating: 5,
			reviewCount: 24,
			reviewScore: 8.5,
			photoURLs: [anyURL()],
			grossPrice: 100.0,
			currency: "USD"
		)
		let hotelsJSON = makeAPIResponseJSON(hotels: [item.json])
		let data = makeJSONData(hotelsJSON)
		let (sut, client) = makeSUT()

		expect(sut, toCompleteWith: .success([item.model]), when: {
			client.completeWith((data, makeHTTPURLResponse(statusCode: 200)))
		})
	}

	// MARK: - Helpers

	private func makeSUT(url: URL = anyURL()) -> (
		sut: HotelsSearchWorker,
		client: HTTPClientSpy
	) {
		let client = HTTPClientSpy()
		let sut = HotelsSearchWorker(
			factory: HotelsRequestFactoryStub(url: url),
			client: client
		)
		return (sut, client)
	}

	private func expect(
		_ sut: HotelsSearchWorker,
		toCompleteWith expectedResult: HotelsSearchService.Result,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let exp = expectation(description: "Wait for completion")

		action()

		sut.search(criteria: anySearchCriteria()) { receivedResult in
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

		wait(for: [exp], timeout: 0.1)
	}

	private func anyValidValues() -> (Data, HTTPURLResponse) {
		let item = anyHotelJSON()
		let hotelsJSON = makeAPIResponseJSON(hotels: [item.json])
		let data = makeJSONData(hotelsJSON)
		return (data, makeHTTPURLResponse(statusCode: 200))
	}

	private func anyHotelJSON() -> (model: Hotel, json: [String: Any]) {
		makeHotelJSON(
			id: 1,
			position: 1,
			name: "any name",
			starRating: 1,
			reviewCount: 1,
			reviewScore: 1.0,
			photoURLs: [],
			grossPrice: 1.0,
			currency: "USD"
		)
	}

	private func makeHotelJSON(
		id: Int,
		position: Int,
		name: String,
		starRating: Int,
		reviewCount: Int,
		reviewScore: Decimal,
		photoURLs: [URL],
		grossPrice: Decimal,
		currency: String
	) -> (model: Hotel, json: [String: Any]) {
		let model = Hotel(
			id: id,
			position: position,
			name: name,
			starRating: starRating,
			reviewCount: reviewCount,
			reviewScore: reviewScore,
			photoURLs: photoURLs,
			price: Price(
				grossPrice: grossPrice,
				currency: currency
			)
		)

		let json = [
			"property": [
				"id": id,
				"position": position,
				"name": name,
				"accuratePropertyClass": starRating,
				"reviewCount": reviewCount,
				"reviewScore": reviewScore,
				"photoUrls": photoURLs.map(\.absoluteString),
				"priceBreakdown": [
					"grossPrice":  [
						"value": grossPrice,
						"currency": currency
					]
				]
			]
		] as [String: Any]

		return (model, json)
	}

	private func makeAPIResponseJSON(
		status: Bool = true,
		message: String = "success",
		hotels: [[String: Any]]
	) -> [String: Any] {
		[
			"status": status,
			"message": message,
			"data": [
				"hotels": hotels
			]
		]
	}
}

final class HotelsRequestFactoryStub: HotelsRequestFactory {
	let url: URL

	init(url: URL) {
		self.url = url
	}

	func makeSearchRequest(criteria: HotelsSearchCriteria) -> URLRequest {
		URLRequest(url: url)
	}
}
