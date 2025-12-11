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
		let entry = cache[key]

		updateRecentUsedKeys(key)

		return entry?.data
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
