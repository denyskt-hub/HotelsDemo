import Foundation

public final class URLSessionHTTPClient: HTTPClient {
	private let session: URLSession

	public static let shared = URLSessionHTTPClient(session: URLSession(configuration: .appDefault))

	public init(session: URLSession = .shared) {
		self.session = session
	}

	public func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		let (data, response) = try await session.data(for: request)

		guard let httpResponse = response as? HTTPURLResponse else {
			throw URLError(.badServerResponse)
		}

		return (data, httpResponse)
	}
}

extension URLSessionConfiguration {
	/// App-wide session configuration: a bounded per-request timeout so a
	/// user-initiated request fails in a predictable window instead of the
	/// 60s default. Caching is left at the protocol default — image loads
	/// share this session and benefit from it; freshness-sensitive endpoints
	/// opt out per request via `cachePolicy`.
	static var appDefault: URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = 30
		return configuration
	}
}
