//
//  PriceRangeDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol PriceRangeDisplayLogic: AnyObject {
	func display(viewModel: PriceRangeModels.Load.ViewModel)
	func displayReset(viewModel: PriceRangeModels.Reset.ViewModel)
	func displaySelect(viewModel: PriceRangeModels.Select.ViewModel)
	func displaySelecting(viewModel: PriceRangeModels.Selecting.ViewModel)
}
