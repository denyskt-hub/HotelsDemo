//
//  PriceRangeBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol PriceRangeBusinessLogic {
	func doFetchPriceRange(request: PriceRangeModels.FetchPriceRange.Request)
	func handlePriceRangeReset(request: PriceRangeModels.PriceRangeReset.Request)
	func handlePriceRangeSelection(request: PriceRangeModels.PriceRangeSelection.Request)
	func handleSelectingPriceRange(request: PriceRangeModels.SelectingPriceRange.Request)
}
