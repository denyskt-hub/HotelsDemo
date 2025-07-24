//
//  HTTPClientSpy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/7/25.
//

import Foundation
import HotelsDemo

struct TaskStub: HTTPClientTask {
	public func cancel() {}
}

final class HTTPClientSpy: HTTPClient {
	private(set) var requests = [URLRequest]()

	private var completions = [(HTTPClient.Result) -> Void]()

	func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
		requests.append(request)
		completions.append(completion)
		return TaskStub()
	}

	func completeWithResult(_ result: HTTPClient.Result, at index: Int = 0) {
		completions[index](result)
	}
}
