public final class LocalImageDataLoader: ImageDataLoader {
	private let store: ImageDataStore

	public init(store: ImageDataStore) {
		self.store = store
	}

	public enum Error: Swift.Error {
		case notFound
	}

	public func load(url: URL) async throws -> Data {
		guard let data = try await store.data(forKey: url.absoluteString) else {
			throw Error.notFound
		}

		return data
	}
}