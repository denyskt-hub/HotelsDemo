//
//  HotelsSearchDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchDisplayLogic: AnyObject {
	func displaySearch(viewModel: HotelsSearchModels.Search.ViewModel)
	func displayLoading(viewModel: HotelsSearchModels.LoadingViewModel)
	func displaySearchError(viewModel: HotelsSearchModels.ErrorViewModel)

	func displayFilters(viewModel: HotelsSearchModels.FetchFilters.ViewModel)
	func displayUpdateFilters(viewModel: HotelsSearchModels.FilterSelection.ViewModel)
}
