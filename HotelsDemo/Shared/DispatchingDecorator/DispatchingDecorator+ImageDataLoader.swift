//
//  DispatchingDecorator+ImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/10/25.
//

import Foundation

extension DispatchingDecorator: ImageDataLoader where T: ImageDataLoader {
	public func load(url: URL) async throws -> Data {
		try await decoratee.load(url: url)
	}
}

public extension ImageDataLoader {
	func dispatch(to dispatcher: Dispatcher) -> ImageDataLoader {
		DispatchingDecorator(decoratee: self, dispatcher: dispatcher)
	}
}
