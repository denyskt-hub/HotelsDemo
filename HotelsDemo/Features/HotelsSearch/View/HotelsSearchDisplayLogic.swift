//
//  HotelsSearchDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchDisplayLogic: AnyObject {
	func displaySearch(viewModel: HotelsSearchModels.Search.ViewModel)
	func displaySearchError(viewModel: HotelsSearchModels.ErrorViewModel)
}
