//
//  StarRatingPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol StarRatingPresentationLogic {
	func present(response: StarRatingModels.FetchStarRating.Response)
	func presentReset(response: StarRatingModels.StarRatingReset.Response)
	func presentSelect(response: StarRatingModels.StarRatingSelection.Response)
}
