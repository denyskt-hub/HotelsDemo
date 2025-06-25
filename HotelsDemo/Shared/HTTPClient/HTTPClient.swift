import Foundation

public protocol HTTPClient: Sendable {
	typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

	func perform(_ request: URLRequest, completion: @escaping (Result) -> Void)
}
