//
//  RetryHTTPClientTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 14.06.2026.
//

import XCTest
import HotelsDemo
import Synchronization

final class RetryHTTPClientTests: XCTestCase {
	func test_perform_doesNotRetryOnSuccess() async throws {
		let (sut, client) = makeSUT(results: [.success(anySuccess())])

		_ = try await sut.perform(anyRequest())

		XCTAssertEqual(client.attemptCount, 1)
	}

	func test_perform_retriesTransientError_thenSucceeds() async throws {
		let (sut, client) = makeSUT(results: [
			.failure(URLError(.timedOut)),
			.success(anySuccess())
		])

		_ = try await sut.perform(anyRequest())

		XCTAssertEqual(client.attemptCount, 2, "Expected one retry after the transient failure")
	}

	func test_perform_exhaustsRetries_thenThrowsLastError() async {
		let (sut, client) = makeSUT(maxRetries: 2, results: [
			.failure(URLError(.timedOut)),
			.failure(URLError(.networkConnectionLost)),
			.failure(URLError(.cannotConnectToHost))
		])

		await assertThrows(URLError.cannotConnectToHost) {
			_ = try await sut.perform(anyRequest())
		}
		XCTAssertEqual(client.attemptCount, 3, "Expected initial attempt + 2 retries")
	}

	func test_perform_doesNotRetryNonTransientError() async {
		let (sut, client) = makeSUT(results: [.failure(URLError(.badServerResponse))])

		await assertThrows(URLError.badServerResponse) {
			_ = try await sut.perform(anyRequest())
		}
		XCTAssertEqual(client.attemptCount, 1, "Non-transient errors must not be retried")
	}

	func test_perform_appliesExponentialBackoffBetweenRetries() async throws {
		let delays = Mutex<[TimeInterval]>([])
		let (sut, _) = makeSUT(
			maxRetries: 2,
			results: [
				.failure(URLError(.timedOut)),
				.failure(URLError(.timedOut)),
				.success(anySuccess())
			],
			sleep: { delay in delays.withLock { $0.append(delay) } }
		)

		_ = try await sut.perform(anyRequest())

		XCTAssertEqual(delays.withLock { $0 }, [0.5, 1.0])
	}

	// MARK: - Helpers

	private func makeSUT(
		maxRetries: Int = 2,
		results: [Result<(Data, HTTPURLResponse), Error>],
		sleep: @escaping @Sendable (TimeInterval) async throws -> Void = { _ in },
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (sut: RetryHTTPClient, client: HTTPClientStub) {
		let client = HTTPClientStub(results: results)
		let sut = RetryHTTPClient(client: client, maxRetries: maxRetries, sleep: sleep)
		trackForMemoryLeaks(sut, file: file, line: line)
		trackForMemoryLeaks(client, file: file, line: line)
		return (sut, client)
	}

	private func anyRequest() -> URLRequest {
		URLRequest(url: URL(string: "https://any-url.com")!)
	}

	private func anySuccess() -> (Data, HTTPURLResponse) {
		(Data(), HTTPURLResponse(url: URL(string: "https://any-url.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
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

private final class HTTPClientStub: HTTPClient {
	private let results: Mutex<[Result<(Data, HTTPURLResponse), Error>]>
	let attemptCountStore = Mutex<Int>(0)

	var attemptCount: Int { attemptCountStore.withLock { $0 } }

	init(results: [Result<(Data, HTTPURLResponse), Error>]) {
		self.results = Mutex(results)
	}

	func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		attemptCountStore.withLock { $0 += 1 }
		let next = results.withLock { $0.isEmpty ? nil : $0.removeFirst() }
		guard let next else { throw URLError(.unknown) }
		return try next.get()
	}
}
