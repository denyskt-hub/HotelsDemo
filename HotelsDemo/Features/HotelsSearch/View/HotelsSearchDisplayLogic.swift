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

	func displayFilter(viewModel: HotelsSearchModels.Filter.ViewModel)
	func displayUpdateFilter(viewModel: HotelsSearchModels.UpdateFilter.ViewModel)
}
