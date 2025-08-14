//
//  DispatchingImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/8/25.
//

import Foundation

public final class DispatchingImageDataLoader: ImageDataLoader {
	private let loader: ImageDataLoader
	private let dispatcher: Dispatcher

	public init(
		loader: ImageDataLoader,
		dispatcher: Dispatcher
	) {
		self.loader = loader
		self.dispatcher = dispatcher
	}

	@discardableResult
	public func load(url: URL, completion: @escaping LoadCompletion) -> ImageDataLoaderTask {
		loader.load(url: url) { [weak self] result in
			guard let self else { return }

			self.dispatcher.dispatch {
				completion(result)
			}
		}
	}
}

public extension ImageDataLoader {
	func dispatch(to dispatcher: Dispatcher) -> ImageDataLoader {
		DispatchingImageDataLoader(loader: self, dispatcher: dispatcher)
	}
}
