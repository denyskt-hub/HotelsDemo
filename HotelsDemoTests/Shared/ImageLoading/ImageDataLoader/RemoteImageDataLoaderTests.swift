//
//  RemoteImageDataLoaderTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import XCTest
import HotelsDemo

final class RemoteImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_init_doesNotSendRequest() {
		let (_, client) = makeSUT()

		XCTAssertEqual(client.receivedRequests(), [])
	}

	func test_load_performsRequest() async throws {
		let url = URL(string: "http://a-url.com/some-path/to/image.jpg")!
		let httpMethod = "GET"
		let (sut, client) = makeSUT()

		client.completeWith((anyData(), makeHTTPURLResponse(statusCode: 200)))
		try await sut.load(url: url)
		await client.waitUntilStarted()

		XCTAssertEqual(client.receivedRequests().first?.url, url)
		XCTAssertEqual(client.receivedRequests().first?.httpMethod, httpMethod)
		XCTAssertEqual(client.receivedRequests().first?.allHTTPHeaderFields, [:])
		XCTAssertEqual(client.receivedRequests().first?.httpBody, nil)
	}

	func test_load_deliversErrorOnClientError() async {
		let clientError = anyNSError()
		let (sut, client) = makeSUT()

		await expect(sut, toLoadWithError: clientError, when: {
			client.completeWithError(clientError)
		})
	}

	func test_load_deliversErrorOnNon200HTTPResponse() async {
		let (sut, client) = makeSUT()

		let samples = [199, 201, 300, 400, 500]
		for statusCode in samples {
			await expect(sut, toLoadWithError: HTTPError.unexpectedStatusCode(statusCode), when: {
				client.completeWith((anyData(), makeHTTPURLResponse(statusCode: statusCode)))
			})
		}
	}

	func test_load_deliversErrorOn200HTTPResponseWithEmptyData() async {
		let (sut, client) = makeSUT()

		await expect(sut, toLoadWithError: ImageDataMapper.Error.invalidData, when: {
			client.completeWith((emptyData(), makeHTTPURLResponse(statusCode: 200)))
		})
	}

	func test_load_deliversDataOn200HTTPResponseWithNonEmptyData() async {
		let nonEmptyData = Data("non-empty data".utf8)
		let (sut, client) = makeSUT()

		await expect(sut, toLoadData: nonEmptyData, when: {
			client.completeWith((nonEmptyData, makeHTTPURLResponse(statusCode: 200)))
		})
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: RemoteImageDataLoader,
		client: HTTPClientSpy
	) {
		let client = HTTPClientSpy()
		let sut = RemoteImageDataLoader(client: client)
		return (sut, client)
	}
}
