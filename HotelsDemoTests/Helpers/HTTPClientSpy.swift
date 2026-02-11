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

	private let stubbedValues = Mutex<(Data, HTTPURLResponse)?>(nil)
	private let stubbedError = Mutex<Error?>(nil)

	private let stream = AsyncStream<Void>.makeStream()

	func receivedRequests() -> [URLRequest] {
		requests.withLock { $0 }
	}

	func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		requests.withLock { $0.append(request) }
		stream.continuation.yield(())

		return try await withCheckedThrowingContinuation { continuation in
			if let stubbedValues = stubbedValues.withLock({ $0 }) {
				continuation.resume(returning: stubbedValues)
			} else if let stubbedError = stubbedError.withLock({ $0 }) {
				continuation.resume(throwing: stubbedError)
			}
		}
	}

	func completeWith(_ values: (Data, HTTPURLResponse)) {
		stubbedValues.withLock { $0 = values }
	}

	func completeWithError(_ error: Error) {
		stubbedError.withLock { $0 = error }
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
