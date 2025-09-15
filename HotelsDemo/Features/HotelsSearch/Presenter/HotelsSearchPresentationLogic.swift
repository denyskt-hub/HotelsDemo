//
//  HotelsSearchPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchPresentationLogic {
	func presentSearch(response: HotelsSearchModels.Search.Response)
	func presentSearchLoading(_ isLoading: Bool)
	func presentSearchError(_ error: Error)

	func presentFilters(response: HotelsSearchModels.FetchFilters.Response)
	func presentUpdateFilters(response: HotelsSearchModels.FilterSelection.Response)
}
