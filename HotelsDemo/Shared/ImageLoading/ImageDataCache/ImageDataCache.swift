//
//  ImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public protocol ImageDataCache {
	typealias SaveResult = Result<Void, Error>
	typealias DataResult = Result<Data?, Error>

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	func save(_ data: Data, forKey key: String, completion: @escaping (SaveResult) -> Void)

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	func data(forKey key: String, completion: @escaping (DataResult) -> Void)
}

extension ImageDataCache {
	public func saveIgnoringResult(_ data: Data, forKey key: String) {
		save(data, forKey: key) { _ in }
	}
}
