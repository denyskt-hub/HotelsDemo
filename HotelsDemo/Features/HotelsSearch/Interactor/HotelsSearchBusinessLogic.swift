//
//  HotelsSearchBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchBusinessLogic {
	func doSearch(request: HotelsSearchModels.Search.Request)
	func doCancelSearch()

	func doFetchFilters(request: HotelsSearchModels.FetchFilters.Request)
	func handleFilterSelection(request: HotelsSearchModels.FilterSelection.Request)
}
