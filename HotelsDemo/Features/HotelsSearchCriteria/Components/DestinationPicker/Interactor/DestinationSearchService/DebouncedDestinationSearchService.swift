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

	public func search(query: String) async throws -> [Destination] {
		try await debouncer.asyncExecute { [weak self] in
			guard let self else { return [] }

			return try await self.decoratee.search(query: query)
		}
	}
}
