//
//  URLSessionHTTPClientTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 07.09.2026.
//

import XCTest
import HotelsDemo
import Synchronization

final class URLSessionHTTPClientTests: XCTestCase {
	override func tearDown() {
		URLProtocolStub.reset()
		super.tearDown()
	}

	func test_perform_sendsGivenRequestToTheNetwork() async throws {
		let sut = makeSUT()
		let sentRequest = Mutex<URLRequest?>(nil)
		URLProtocolStub.stub(response: okResponse(), data: emptyData()) { request in
			sentRequest.withLock { $0 = request }
		}

		var request = URLRequest(url: URL(string: "https://a-given-url.com/search")!)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = Data(#"{"query":"paris"}"#.utf8)

		_ = try await sut.perform(request)

		let sent = try XCTUnwrap(sentRequest.withLock { $0 })
		XCTAssertEqual(sent.url, request.url)
		XCTAssertEqual(sent.httpMethod, "POST")
		XCTAssertEqual(sent.value(forHTTPHeaderField: "Content-Type"), "application/json")
		XCTAssertEqual(sent.streamedBodyData(), request.httpBody, "Expected the body to reach the loader unchanged")
	}

	func test_perform_deliversDataAndResponseOnHTTPURLResponse() async throws {
		let sut = makeSUT()
		let data = Data("a response body".utf8)
		URLProtocolStub.stub(response: response(statusCode: 418, headers: ["X-Quota": "10"]), data: data)

		let (receivedData, receivedResponse) = try await sut.perform(anyRequest())

		XCTAssertEqual(receivedData, data)
		XCTAssertEqual(receivedResponse.statusCode, 418)
		XCTAssertEqual(receivedResponse.value(forHTTPHeaderField: "X-Quota"), "10")
	}

	func test_perform_deliversEmptyDataOnResponseWithoutBody() async throws {
		let sut = makeSUT()
		URLProtocolStub.stub(response: okResponse(), data: nil)

		let (receivedData, receivedResponse) = try await sut.perform(anyRequest())

		XCTAssertEqual(receivedData, Data(), "A body-less response is a success, not a failure")
		XCTAssertEqual(receivedResponse.statusCode, 200)
	}

	func test_perform_throwsBadServerResponseOnNonHTTPURLResponse() async {
		let sut = makeSUT()
		URLProtocolStub.stub(response: nonHTTPResponse(), data: anyData())

		await assertThrows(.badServerResponse) {
			_ = try await sut.perform(anyRequest())
		}
	}

	func test_perform_throwsTransportErrorUnchanged() async {
		let sut = makeSUT()
		URLProtocolStub.stub(error: URLError(.notConnectedToInternet))

		await assertThrows(.notConnectedToInternet) {
			_ = try await sut.perform(anyRequest())
		}
	}

	// `HotelsSearchInteractor` treats a cancelled search as "no result to present"
	// by matching `URLError.cancelled`, not `CancellationError`. That distinction
	// is a property of `URLSession`, so it is pinned here rather than assumed.
	func test_perform_throwsCancelledURLErrorWhenSurroundingTaskIsCancelled() async {
		let sut = makeSUT()
		let didReachLoader = expectation(description: "Wait for the request to reach the loader")
		URLProtocolStub.stubNeverCompletingRequest { _ in didReachLoader.fulfill() }

		let request = anyRequest()
		let task = Task { try await sut.perform(request) }
		await fulfillment(of: [didReachLoader], timeout: 1.0)
		task.cancel()

		switch await task.result {
		case .success:
			XCTFail("Expected the cancelled request to fail")
		case let .failure(error):
			XCTAssertEqual(
				(error as? URLError)?.code,
				.cancelled,
				"Expected URLError.cancelled, got \(error)"
			)
		}
	}

	// MARK: - Helpers

	private func makeSUT(
		file: StaticString = #filePath,
		line: UInt = #line
	) -> URLSessionHTTPClient {
		let configuration = URLSessionConfiguration.ephemeral
		configuration.protocolClasses = [URLProtocolStub.self]
		let session = URLSession(configuration: configuration)
		addTeardownBlock { session.invalidateAndCancel() }

		let sut = URLSessionHTTPClient(session: session)
		trackForMemoryLeaks(sut, file: file, line: line)
		return sut
	}

	private func anyRequest() -> URLRequest {
		URLRequest(url: anyURL())
	}

	private func okResponse() -> HTTPURLResponse {
		response(statusCode: 200)
	}

	private func response(statusCode: Int, headers: [String: String]? = nil) -> HTTPURLResponse {
		HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: headers)!
	}

	private func nonHTTPResponse() -> URLResponse {
		URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
	}

	private func assertThrows(
		_ expected: URLError.Code,
		file: StaticString = #filePath,
		line: UInt = #line,
		_ block: () async throws -> Void
	) async {
		do {
			try await block()
			XCTFail("Expected to throw \(expected)", file: file, line: line)
		} catch let error as URLError {
			XCTAssertEqual(error.code, expected, file: file, line: line)
		} catch {
			XCTFail("Expected URLError \(expected), got \(error)", file: file, line: line)
		}
	}
}

private final class URLProtocolStub: URLProtocol {
	private struct Stub {
		let data: Data?
		let response: URLResponse?
		let error: Error?
		let completes: Bool
		let onStart: (@Sendable (URLRequest) -> Void)?
	}

	private static let state = Mutex<Stub?>(nil)

	static func stub(
		response: URLResponse? = nil,
		data: Data? = nil,
		error: Error? = nil,
		onStart: (@Sendable (URLRequest) -> Void)? = nil
	) {
		state.withLock {
			$0 = Stub(data: data, response: response, error: error, completes: true, onStart: onStart)
		}
	}

	/// Accepts the request and never answers it, so the only way out is cancellation.
	static func stubNeverCompletingRequest(onStart: (@Sendable (URLRequest) -> Void)? = nil) {
		state.withLock {
			$0 = Stub(data: nil, response: nil, error: nil, completes: false, onStart: onStart)
		}
	}

	static func reset() {
		state.withLock { $0 = nil }
	}

	override static func canInit(with request: URLRequest) -> Bool { true }

	override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }

	override func startLoading() {
		guard let stub = URLProtocolStub.state.withLock({ $0 }) else {
			client?.urlProtocol(self, didFailWithError: URLError(.unknown))
			return
		}

		stub.onStart?(request)

		guard stub.completes else { return }

		if let error = stub.error {
			return client?.urlProtocol(self, didFailWithError: error) ?? ()
		}

		if let response = stub.response {
			client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		}
		if let data = stub.data {
			client?.urlProtocol(self, didLoad: data)
		}
		client?.urlProtocolDidFinishLoading(self)
	}

	override func stopLoading() {}
}

private extension URLRequest {
	/// A request that has reached the loader carries its body in `httpBodyStream`.
	/// `URLSession` moves `httpBody` there before `canInit(with:)` runs, so
	/// `httpBody` is nil at every `URLProtocol` stage and asserting on it would
	/// fail on a body that was in fact sent.
	func streamedBodyData() -> Data? {
		guard let stream = httpBodyStream else { return nil }

		stream.open()
		defer { stream.close() }

		var data = Data()
		var buffer = [UInt8](repeating: 0, count: 1024)
		while stream.hasBytesAvailable {
			let read = stream.read(&buffer, maxLength: buffer.count)
			guard read > 0 else { break }
			data.append(buffer, count: read)
		}
		return data
	}
}
