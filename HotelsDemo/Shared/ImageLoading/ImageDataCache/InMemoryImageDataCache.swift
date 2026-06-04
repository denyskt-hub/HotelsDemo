//
//  InMemoryImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public actor InMemoryImageDataCache: ImageDataCache {
	private struct CacheEntry {
		let data: Data
		let size: Int
	}

	private var cache = [String: CacheEntry]()
	private var recentUsedKeys = [String]()
	private var totalSizeInBytes = 0

	private let countLimit: Int?
	private let sizeLimitInBytes: Int?

	public init(
		countLimit: Int? = nil,
		sizeLimitInBytes: Int? = nil
	) {
		self.countLimit = countLimit
		self.sizeLimitInBytes = sizeLimitInBytes
	}

	public func save(_ data: Data, forKey key: String) async throws {
		let entry = CacheEntry(data: data, size: data.count)
		updateEntry(entry, forKey: key)

		updateRecentUsedKeys(key)

		evictIfNeeded()
	}

	@discardableResult
	public func data(forKey key: String) async throws -> Data? {
		// Recency must only be updated on a hit: tracking misses would grow
		// `recentUsedKeys` unboundedly with phantom keys that no eviction
		// can remove (they hold no cache entry, so they never trip a limit).
		guard let entry = cache[key] else {
			return nil
		}

		updateRecentUsedKeys(key)

		return entry.data
	}

	/// LRU bookkeeping size — test-facing observability.
	var trackedKeysCount: Int {
		recentUsedKeys.count
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
