//
//  DebouncedDestinationSearchService.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/10/25.
//

import Foundation

public final class DebouncedDestinationSearchService: DestinationSearchService {
	private let decoratee: DestinationSearchService
	private let debouncer: Debouncer

	public init(
		decoratee: DestinationSearchService,
		debouncer: Debouncer
	) {
		self.decoratee = decoratee
		self.debouncer = debouncer
	}

	public func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		debouncer.execute { [weak self] in
			self?.decoratee.search(query: query, completion: completion)
		}
	}
}
