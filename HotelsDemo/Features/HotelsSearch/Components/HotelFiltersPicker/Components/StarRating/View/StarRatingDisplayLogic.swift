//
//  StarRatingDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol StarRatingDisplayLogic: AnyObject {
	func display(viewModel: StarRatingModels.Load.ViewModel)
	func displayReset(viewModel: StarRatingModels.Reset.ViewModel)
	func displaySelect(viewModel: StarRatingModels.Select.ViewModel)
}
