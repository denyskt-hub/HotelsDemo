//
//  HotelsSearchBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchBusinessLogic {
	func search(request: HotelsSearchModels.Search.Request)
	func cancelSearch()

	func filters(request: HotelsSearchModels.Filter.Request)
	func updateFilters(request: HotelsSearchModels.UpdateFilter.Request)
}
