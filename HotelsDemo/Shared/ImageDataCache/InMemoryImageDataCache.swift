//
//  InMemoryImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public final class InMemoryImageDataCache: ImageDataCache {
	private let queue = DispatchQueue(
		label: "\(InMemoryImageDataCache.self)Queue",
		qos: .userInitiated,
		attributes: .concurrent
	)

	private var cache: [String: Data] = [:]

	public func save(_ data: Data, forKey key: String, completion: @escaping (Error?) -> Void) {
		queue.async(flags: .barrier) { [weak self] in
			self?.cache[key] = data
			completion(nil)
		}
	}
	
	public func data(forKey key: String, completion: @escaping (Result<Data?, Error>) -> Void) {
		queue.async { [weak self] in
			guard let self = self else { return }
			completion(.success(cache[key]))
		}
	}
}
