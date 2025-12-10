//
//  InMemoryImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation
import Synchronization

public final class InMemoryImageDataCache: ImageDataCache {
	private struct CacheEntry {
		let data: Data
		let size: Int
	}

	private let cache = Mutex<[String: CacheEntry]>([:])
	private let recentUsedKeys = Mutex<[String]>([])
	private let totalSizeInBytes = Mutex<Int>(0)

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
		let entry = cache.withLock { $0[key] }

		updateRecentUsedKeys(key)

		return entry?.data
	}

	private func updateEntry(_ entry: CacheEntry, forKey key: String) {
		if let existingEntry = cache.withLock({ $0[key] }) {
			totalSizeInBytes.withLock { $0 -= existingEntry.size }
		}

		cache.withLock { $0[key] = entry }
		totalSizeInBytes.withLock { $0 += entry.size }
	}

	private func updateRecentUsedKeys(_ key: String) {
		recentUsedKeys.withLock { $0.removeAll { $0 == key } }
		recentUsedKeys.withLock { $0.insert(key, at: 0) }
	}

	private func evictIfNeeded() {
		while exceedsLimits() {
			evictLeastRecentlyUsed()
		}
	}

	private func exceedsLimits() -> Bool {
		if let countLimit = countLimit, cache.withLock({ $0.count }) > countLimit {
			return true
		}
		if let sizeLimitInBytes = sizeLimitInBytes, totalSizeInBytes.withLock({ $0 }) > sizeLimitInBytes {
			return true
		}
		return false
	}

	private func evictLeastRecentlyUsed() {
		guard let lastKey = recentUsedKeys.withLock({ $0.popLast() }) else {
			return
		}

		if let entry = cache.withLock({ $0.removeValue(forKey: lastKey) }) {
			totalSizeInBytes.withLock { $0 -= entry.size }
		}
	}
}
