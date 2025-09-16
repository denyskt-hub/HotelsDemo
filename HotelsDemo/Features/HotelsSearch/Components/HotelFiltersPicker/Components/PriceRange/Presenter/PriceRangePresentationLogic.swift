//
//  PriceRangePresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol PriceRangePresentationLogic {
	func present(response: PriceRangeModels.FetchPriceRange.Response)
	func presentReset(response: PriceRangeModels.ResetPriceRange.Response)
	func presentSelect(response: PriceRangeModels.PriceRangeSelection.Response)
	func presentSelecting(response: PriceRangeModels.SelectingPriceRange.Response)
}
