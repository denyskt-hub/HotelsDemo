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
	typealias LoadResult = Result<Data, Error>
	typealias LoadCompletion = (LoadResult) -> Void

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	@discardableResult
	func load(url: URL, completion: @escaping LoadCompletion) -> ImageDataLoaderTask
}
