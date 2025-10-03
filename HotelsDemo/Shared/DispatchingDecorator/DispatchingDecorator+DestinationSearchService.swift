//
//  DispatchingDecorator+DestinationSearchService.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/10/25.
//

import Foundation

extension DispatchingDecorator: DestinationSearchService where T: DestinationSearchService {
	public func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		decoratee.search(query: query, completion: dispatching(completion))
	}
}

public extension DestinationSearchService {
	func dispatch(to dispatcher: Dispatcher) -> DestinationSearchService {
		DispatchingDecorator(decoratee: self, dispatcher: dispatcher)
	}
}
