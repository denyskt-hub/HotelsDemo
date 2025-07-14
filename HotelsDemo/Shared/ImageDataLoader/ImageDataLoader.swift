//
//  ImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import Foundation

public protocol ImageDataLoaderTask {
	func cancel()
}

public protocol ImageDataLoader {
	typealias Result = Swift.Result<Data, Error>

	func load(url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask
}
