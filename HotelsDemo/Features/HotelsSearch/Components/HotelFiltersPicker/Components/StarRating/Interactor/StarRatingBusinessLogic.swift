//
//  StarRatingBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol StarRatingBusinessLogic {
	func load(request: StarRatingModels.Load.Request)
	func reset(request: StarRatingModels.Reset.Request)
	func select(request: StarRatingModels.Select.Request)
}
