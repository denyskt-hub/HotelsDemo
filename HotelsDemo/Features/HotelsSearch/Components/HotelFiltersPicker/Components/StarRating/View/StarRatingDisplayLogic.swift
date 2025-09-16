//
//  StarRatingDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol StarRatingDisplayLogic: AnyObject {
	func display(viewModel: StarRatingModels.FetchStarRating.ViewModel)
	func displayReset(viewModel: StarRatingModels.StarRatingReset.ViewModel)
	func displaySelect(viewModel: StarRatingModels.StarRatingSelection.ViewModel)
}
