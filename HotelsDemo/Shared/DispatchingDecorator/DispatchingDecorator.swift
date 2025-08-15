//
//  DispatchingDecorator.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/8/25.
//

import Foundation

public final class DispatchingDecorator<T> {
	private let decoratee: T
	private let dispatcher: Dispatcher

	public init(
		decoratee: T,
		dispatcher: Dispatcher
	) {
		self.decoratee = decoratee
		self.dispatcher = dispatcher
	}

	public func dispatching<Output>(_ completion: @escaping (Output) -> Void) -> (Output) -> Void {
		{ [weak self] value in
			self?.dispatcher.dispatch {
				completion(value)
			}
		}
	}
}

// MARK: - ImageDataLoader

extension DispatchingDecorator: ImageDataLoader where T: ImageDataLoader {
	public func load(url: URL, completion: @escaping LoadCompletion) -> ImageDataLoaderTask {
		decoratee.load(url: url, completion: dispatching(completion))
	}
}

public extension ImageDataLoader {
	func dispatch(to dispatcher: Dispatcher) -> ImageDataLoader {
		DispatchingDecorator(decoratee: self, dispatcher: dispatcher)
	}
}

// MARK: - HotelsSearchCriteriaCache

extension DispatchingDecorator: HotelsSearchCriteriaCache where T: HotelsSearchCriteriaCache {
	public func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void) {
		decoratee.save(criteria, completion: dispatching(completion))
	}
}

// MARK: - HotelsSearchCriteriaProvider

extension DispatchingDecorator: HotelsSearchCriteriaProvider where T: HotelsSearchCriteriaProvider {
	public func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		decoratee.retrieve(completion: dispatching(completion))
	}
}

// MARK: - HotelsSearchCriteriaStore

extension DispatchingDecorator: HotelsSearchCriteriaStore where T: HotelsSearchCriteriaStore {}

public extension HotelsSearchCriteriaStore {
	func dispatch(to dispatcher: Dispatcher) -> HotelsSearchCriteriaStore {
		DispatchingDecorator(decoratee: self, dispatcher: dispatcher)
	}
}
