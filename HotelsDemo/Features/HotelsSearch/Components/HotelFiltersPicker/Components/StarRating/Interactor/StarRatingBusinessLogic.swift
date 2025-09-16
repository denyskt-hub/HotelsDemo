//
//  StarRatingBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol StarRatingBusinessLogic {
	func doFetchStarRating(request: StarRatingModels.FetchStarRating.Request)
	func handleStarRatingReset(request: StarRatingModels.StarRatingReset.Request)
	func handleStarRatingSelection(request: StarRatingModels.StarRatingSelection.Request)
}
