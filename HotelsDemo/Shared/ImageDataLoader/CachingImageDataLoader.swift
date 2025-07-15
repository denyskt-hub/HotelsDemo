public final class CachingImageDataLoader: ImageDataLoader {
	private let loader: ImageDataLoader
	private let cache: ImageDataCache

	public init(
		loader: ImageDataLoader,
		cache: ImageDataCache
	) {
		self.loader = loader
		self.cache = cache
	}

	public func load(url: URL) async throws -> Data {
		let data = try await loader.load(url: url)

		try? await cache.save(data, for: url)

		return data
	}
}
