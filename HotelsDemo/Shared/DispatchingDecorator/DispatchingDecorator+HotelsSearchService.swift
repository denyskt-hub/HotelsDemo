//
//  DispatchingDecorator+HotelsSearchService.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/10/25.
//

import Foundation

extension DispatchingDecorator: HotelsSearchService where T: HotelsSearchService {
	public func search(
		criteria: HotelsSearchCriteria,
		completion: @escaping (HotelsSearchService.Result) -> Void
	) -> HTTPClientTask {
		decoratee.search(criteria: criteria, completion: dispatching(completion))
	}
}

public extension HotelsSearchService {
	func dispatch(to dispatcher: Dispatcher) -> HotelsSearchService {
		DispatchingDecorator(decoratee: self, dispatcher: dispatcher)
	}
}
