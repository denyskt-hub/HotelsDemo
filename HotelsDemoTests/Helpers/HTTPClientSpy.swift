//
//  HTTPClientSpy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/7/25.
//

import Foundation
import HotelsDemo
import Synchronization

final class HTTPClientSpy: HTTPClient {
	let requests = Mutex<[URLRequest]>([])

	private let stubbedResult = Mutex<Result<(Data, HTTPURLResponse), Error>?>(nil)
	private let continuations = Mutex<[CheckedContinuation<(Data, HTTPURLResponse), Error>]>([])

	private let stream = AsyncStream<Void>.makeStream()

	func receivedRequests() -> [URLRequest] {
		requests.withLock { $0 }
	}

	func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		requests.withLock { $0.append(request) }
		stream.continuation.yield(())

		return try await withCheckedThrowingContinuation { continuation in
			if let result = stubbedResult.withLock({ $0 }) {
				continuation.resume(with: result)
			} else {
				continuations.withLock { $0.append(continuation) }
			}
		}
	}

	/// Pre-sets a persistent result delivered to every subsequent `perform`.
	func stubWith(_ values: (Data, HTTPURLResponse)) {
		stubbedResult.withLock { $0 = .success(values) }
	}

	/// Pre-sets a persistent error delivered to every subsequent `perform`.
	func stubWithError(_ error: Error) {
		stubbedResult.withLock { $0 = .failure(error) }
	}

	/// Completes an in-flight `perform` that suspended without a stub.
	func completeWith(_ values: (Data, HTTPURLResponse), at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(returning: values)
	}

	/// Fails an in-flight `perform` that suspended without a stub.
	func completeWithError(_ error: Error, at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(throwing: error)
	}

	func waitUntilStarted() async {
		var iterator = stream.stream.makeAsyncIterator()
		_ = await iterator.next()
	}
}

func makeAppHTTPClientSpy() -> (client: AppHTTPClient, spy: HTTPClientSpy) {
	let spy = HTTPClientSpy()
	let sut = AppHTTPClient(decoratee: spy)
	return (sut, spy)
}
