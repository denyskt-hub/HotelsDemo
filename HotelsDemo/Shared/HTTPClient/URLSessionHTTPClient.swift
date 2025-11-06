import Foundation

public final class URLSessionHTTPClient: HTTPClient {
	private let session: URLSession

	public static let shared = URLSessionHTTPClient()

	public init(session: URLSession = .shared) {
		self.session = session
	}

	private struct URLSessionTaskWrapper: HTTPClientTask {
		let wrapped: URLSessionTask

		func cancel() {
			wrapped.cancel()
		}
	}

	public func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
		let task = session.dataTask(with: request) { data, response, error in
			guard let data = data else {
				completion(.failure(error ?? URLError(.badServerResponse)))
				return
			}

			guard let httpResponse = response as? HTTPURLResponse else {
				completion(.failure(URLError(.badServerResponse)))
				return
			}

			completion(.success((data, httpResponse)))
		}
		task.resume()
		return URLSessionTaskWrapper(wrapped: task)
	}

	public func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		let (data, response) = try await session.data(for: request)

		guard let httpResponse = response as? HTTPURLResponse else {
			throw URLError(.badServerResponse)
		}

		return (data, httpResponse)
	}
}
