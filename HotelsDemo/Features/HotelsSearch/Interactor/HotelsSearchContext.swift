//
//  HotelsSearchContext.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 17/10/25.
//

import Foundation

///
/// A context object that encapsulates dependencies for the HotelsSearchInteractor.
/// - Contains the criteria provider and search service.
/// 
public struct HotelsSearchContext: Sendable {
	public let provider: HotelsSearchCriteriaProvider
	public let service: HotelsSearchService

	public init(
		provider: HotelsSearchCriteriaProvider,
		service: HotelsSearchService
	) {
		self.provider = provider
		self.service = service
	}
}
