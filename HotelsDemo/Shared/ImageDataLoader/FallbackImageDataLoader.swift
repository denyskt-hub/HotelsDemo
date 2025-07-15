public final class FallbackImageDataLoader: ImageDataLoader {
	private let primary: ImageDataLoader
	private let secondary: ImageDataLoader

	public init(
		primary: ImageDataLoader,
		secondary: ImageDataLoader
	) {
		self.primary = primary
		self.secondary = secondary
	}

	public func load(url: URL) async throws -> Data {
		do {
			return try await primary.load(url: url)
		} catch {
			return try await secondary.load(url: url)
		}
	}
}

public extension ImageDataLoader {
	func fallback(to secondary: ImageDataLoader) -> ImageDataLoader {
		FallbackImageDataLoader(primary: self, secondary: secondary)
	}
}