//
//  PriceRangeDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol PriceRangeDisplayLogic: AnyObject {
	func display(viewModel: PriceRangeModels.FetchPriceRange.ViewModel)
	func displayReset(viewModel: PriceRangeModels.PriceRangeReset.ViewModel)
	func displaySelect(viewModel: PriceRangeModels.PriceRangeSelection.ViewModel)
	func displaySelecting(viewModel: PriceRangeModels.SelectingPriceRange.ViewModel)
}
