//
//  DispatchingDecorator+ImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/10/25.
//

import Foundation

extension DispatchingDecorator: ImageDataLoader where T: ImageDataLoader {
	public func load(url: URL, completion: @Sendable @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		decoratee.load(url: url, completion: dispatching(completion))
	}
}

public extension ImageDataLoader {
	func dispatch(to dispatcher: Dispatcher) -> ImageDataLoader {
		DispatchingDecorator(decoratee: self, dispatcher: dispatcher)
	}
}
