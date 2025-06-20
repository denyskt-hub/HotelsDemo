import Foundation

final class URLSessionHTTPClient: HTTPClient {
	private let session: URLSession
	
	init(session: URLSession = .shared) {
		self.session = session
	}

	func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
		session.dataTask(with: request) { data, response, error in
			guard let data = data else {
				completion(.failure(error ?? URLError(.badServerResponse)))
				return
			}
			
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(.failure(URLError(.badServerResponse)))
				return
			}

			completion(.success((data, httpResponse)))
		}.resume()
	}
}
