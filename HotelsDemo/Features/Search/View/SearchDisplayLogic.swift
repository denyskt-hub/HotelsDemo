//
//  SearchDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol SearchDisplayLogic: AnyObject {
	func displaySearch(viewModel: SearchModels.Search.ViewModel)
	func displaySearchError(viewModel: SearchModels.ErrorViewModel)
}
