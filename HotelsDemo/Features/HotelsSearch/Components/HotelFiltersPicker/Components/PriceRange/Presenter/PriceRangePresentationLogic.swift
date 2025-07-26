//
//  PriceRangePresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol PriceRangePresentationLogic {
	func present(response: PriceRangeModels.Load.Response)
	func presentReset(response: PriceRangeModels.Reset.Response)
	func presentSelect(response: PriceRangeModels.Select.Response)
	func presentSelecting(response: PriceRangeModels.Selecting.Response)
}
