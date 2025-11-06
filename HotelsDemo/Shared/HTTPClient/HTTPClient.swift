import Foundation

public protocol HTTPClientTask {
	func cancel()
}

public protocol HTTPClient: Sendable {
	typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	@discardableResult
	@available(*, deprecated, message: "Use async version")
	func perform(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask

	func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

extension HTTPClient {
	public func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		nonisolated(unsafe) var task: HTTPClientTask?

		return try await withTaskCancellationHandler {
			return try await withCheckedThrowingContinuation { continuation in
				task = perform(request) { result in
					switch result {
					case let .success((data, response)):
						continuation.resume(returning: (data, response))
					case let .failure(error):
						continuation.resume(throwing: error)
					}
				}
			}
		} onCancel: {
			task?.cancel()
		}
	}
}
