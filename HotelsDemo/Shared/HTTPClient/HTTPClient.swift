import Foundation

public protocol HTTPClientTask {
	func cancel()
}

public protocol HTTPClient: Sendable {
	func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
