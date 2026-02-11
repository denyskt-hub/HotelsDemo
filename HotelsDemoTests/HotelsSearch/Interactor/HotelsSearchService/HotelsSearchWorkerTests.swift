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

	func test_search_performsRequestWithCorrectURL() async throws {
		let expectedURL = URL(string: "https://api.com/hotels/search")!
		let (sut, client) = makeSUT(url: expectedURL)

		client.completeWith(anyValidValues())
		_ = try await sut.search(criteria: anySearchCriteria())

		XCTAssertEqual(client.receivedRequests().map(\.url), [expectedURL])
	}

	func test_search_deliversErrorOnClientError() async {
		let clientError = anyNSError()
		let (sut, client) = makeSUT()

		await expect(sut, toCompleteWithError: clientError, when: {
			client.completeWithError(clientError)
		})
	}

	func test_search_deliversErrorOnNon200HTTPResponse() async {
		let samples = [199, 300, 350, 404, 500]
		let (sut, client) = makeSUT()

		for statusCode in samples {
			await expect(sut, toCompleteWithError: AppError.http(.unexpectedStatusCode(statusCode)), when: {
				client.completeWith((anyData(), makeHTTPURLResponse(statusCode: statusCode)))
			})
		}
	}

	func test_search_deliversErrorOn200HTTPResponseWithEmptyDataOrInvalidJSON() async {
		let samples = [emptyData(), invalidJSONData()]
		let (sut, client) = makeSUT()

		for data in samples {
			await expect(sut, toCompleteWithError: AppError.api(.decoding(anyNSError())), when: {
				client.completeWith((data, makeHTTPURLResponse(statusCode: 200)))
			})
		}
	}

	func test_search_deliversResultOn200HTTPResponseWithValidJSON() async throws {
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

		try await expect(sut, toCompleteWithHotels: [item.model], when: {
			client.completeWith((data, makeHTTPURLResponse(statusCode: 200)))
		})
	}

	// MARK: - Helpers

	private func makeSUT(url: URL = anyURL()) -> (
		sut: HotelsSearchWorker,
		client: HTTPClientSpy
	) {
		let (client, spy) = makeAppHTTPClientSpy()
		let sut = HotelsSearchWorker(
			factory: HotelsRequestFactoryStub(url: url),
			client: client
		)
		return (sut, spy)
	}

	private func expect(
		_ sut: HotelsSearchWorker,
		toCompleteWithHotels expectedHotels: [Hotel],
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) async throws {
		action()

		let receivedHotels = try await sut.search(criteria: anySearchCriteria())

		XCTAssertEqual(receivedHotels, expectedHotels, file: file, line: line)
	}

	private func expect(
		_ sut: HotelsSearchWorker,
		toCompleteWithError expectedError: Error,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) async {
		action()

		var receivedError: NSError?
		do {
			_ = try await sut.search(criteria: anySearchCriteria())
		} catch {
			receivedError = error as NSError
		}

		XCTAssertEqual(receivedError, expectedError as NSError, file: file, line: line)
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
