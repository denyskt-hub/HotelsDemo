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

	public func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		let (data, response) = try await session.data(for: request)

		guard let httpResponse = response as? HTTPURLResponse else {
			throw URLError(.badServerResponse)
		}

		return (data, httpResponse)
	}
}
