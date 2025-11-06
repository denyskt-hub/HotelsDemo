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

	func test_load_performsRequest() {
		let url = URL(string: "http://a-url.com/some-path/to/image.jpg")!
		let httpMethod = "GET"
		let (sut, client) = makeSUT()

		sut.load(url: url) { _ in }

		XCTAssertEqual(client.receivedRequests().first?.url, url)
		XCTAssertEqual(client.receivedRequests().first?.httpMethod, httpMethod)
		XCTAssertEqual(client.receivedRequests().first?.allHTTPHeaderFields, [:])
		XCTAssertEqual(client.receivedRequests().first?.httpBody, nil)
	}

	func test_load_deliversErrorOnClientError() {
		let clientError = anyNSError()
		let (sut, client) = makeSUT()

		expect(sut, toLoad: .failure(clientError), when: {
			client.completeWithError(clientError)
		})
	}

	func test_load_deliversErrorOnNon200HTTPResponse() {
		let (sut, client) = makeSUT()

		let samples = [199, 201, 300, 400, 500]
		for statusCode in samples {
			expect(sut, toLoad: .failure(HTTPError.unexpectedStatusCode(statusCode)), when: {
				client.completeWith((anyData(), makeHTTPURLResponse(statusCode: statusCode)))
			})
		}
	}

	func test_load_deliversErrorOn200HTTPResponseWithEmptyData() {
		let (sut, client) = makeSUT()

		expect(sut, toLoad: .failure(ImageDataMapper.Error.invalidData), when: {
			client.completeWith((emptyData(), makeHTTPURLResponse(statusCode: 200)))
		})
	}

	func test_load_deliversDataOn200HTTPResponseWithNonEmptyData() {
		let nonEmptyData = Data("non-empty data".utf8)
		let (sut, client) = makeSUT()

		expect(sut, toLoad: .success(nonEmptyData), when: {
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

	func expect(
		_ sut: ImageDataLoader,
		toLoad expectedResult: ImageDataLoader.LoadResult,
		when action: () -> Void,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let exp = expectation(description: "Wait to complete")

		action()

		sut.load(url: anyURL()) { receivedResult in
			XCTAssertDataResultEqual(receivedResult, expectedResult, file: file, line: line)
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
	}
}
