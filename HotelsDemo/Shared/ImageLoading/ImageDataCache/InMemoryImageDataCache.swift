//
//  InMemoryImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public final class InMemoryImageDataCache: ImageDataCache, @unchecked Sendable {
	private let queue = DispatchQueue(
		label: "\(InMemoryImageDataCache.self)Queue",
		qos: .userInitiated,
		attributes: .concurrent
	)

	private struct CacheEntry {
		let data: Data
		let size: Int
	}

	private var cache = [String: CacheEntry]()
	private var recentUsedKeys = [String]()
	private var totalSizeInBytes: Int = 0

	private let countLimit: Int?
	private let sizeLimitInBytes: Int?

	public init(
		countLimit: Int? = nil,
		sizeLimitInBytes: Int? = nil
	) {
		self.countLimit = countLimit
		self.sizeLimitInBytes = sizeLimitInBytes
	}

	public func save(_ data: Data, forKey key: String, completion: @Sendable @escaping (SaveResult) -> Void) {
		queue.async(flags: .barrier) { [weak self] in
			guard let self = self else { return }

			let entry = CacheEntry(data: data, size: data.count)
			self.updateEntry(entry, forKey: key)

			self.updateRecentUsedKeys(key)

			self.evictIfNeeded()

			completion(.success(()))
		}
	}

	public func data(forKey key: String, completion: @Sendable @escaping (DataResult) -> Void) {
		queue.async(flags: .barrier) { [weak self] in
			guard let self = self else { return }

			let entry = cache[key]

			updateRecentUsedKeys(key)

			completion(.success(entry?.data))
		}
	}

	private func updateEntry(_ entry: CacheEntry, forKey key: String) {
		if let existingEntry = cache[key] {
			totalSizeInBytes -= existingEntry.size
		}

		cache[key] = entry
		totalSizeInBytes += entry.size
	}

	private func updateRecentUsedKeys(_ key: String) {
		recentUsedKeys.removeAll { $0 == key }
		recentUsedKeys.insert(key, at: 0)
	}

	private func evictIfNeeded() {
		while exceedsLimits() {
			evictLeastRecentlyUsed()
		}
	}

	private func exceedsLimits() -> Bool {
		if let countLimit = countLimit, cache.count > countLimit {
			return true
		}
		if let sizeLimitInBytes = sizeLimitInBytes, totalSizeInBytes > sizeLimitInBytes {
			return true
		}
		return false
	}

	private func evictLeastRecentlyUsed() {
		guard let lastKey = recentUsedKeys.popLast() else {
			return
		}

		if let entry = cache.removeValue(forKey: lastKey) {
			totalSizeInBytes -= entry.size
		}
	}
}
