//
//  PriceRangeBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol PriceRangeBusinessLogic {
	func load(request: PriceRangeModels.Load.Request)
	func reset(request: PriceRangeModels.Reset.Request)
	func select(request: PriceRangeModels.Select.Request)
	func selecting(request: PriceRangeModels.Selecting.Request)
}
