//
//  ImageDataCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public protocol ImageDataCache {
	func save(_ data: Data, forKey key: String, completion: @escaping (Error?) -> Void)
	func data(forKey key: String, completion: @escaping (Result<Data?, Error>) -> Void)
}
