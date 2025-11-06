//
//  HTTPClientSpy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/7/25.
//

import Foundation
import HotelsDemo
import Synchronization

struct TaskStub: HTTPClientTask {
	public func cancel() {}
}

final class HTTPClientSpy: HTTPClient {
	let requests = Mutex<[URLRequest]>([])

	private let completions = Mutex<[(HTTPClient.Result) -> Void]>([])
	
	private let stream = AsyncStream<Void>.makeStream()

	func receivedRequests() -> [URLRequest] {
		requests.withLock { $0 }
	}

	func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
		requests.withLock { $0.append(request) }
		completions.withLock { $0.append(completion) }

		return TaskStub()
	}

	func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		requests.withLock { $0.append(request) }
		stream.continuation.yield(())

		return try await withCheckedThrowingContinuation { continuation in
			if let stubbedValues = stubbedValues.withLock({ $0 }) {
				continuation.resume(returning: stubbedValues)
			}
			if let stubbedError = stubbedError.withLock({ $0 }) {
				continuation.resume(throwing: stubbedError)
			}
		}
	}

	func completeWithResult(_ result: HTTPClient.Result, at index: Int = 0) {
		let completion = completions.withLock { $0[index] }
		completion(result)
	}

	private let stubbedValues = Mutex<(Data, HTTPURLResponse)?>(nil)
	private let stubbedError = Mutex<Error?>(nil)

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
