//
//  StarRatingPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public protocol StarRatingPresentationLogic {
	func present(response: StarRatingModels.Load.Response)
	func presentReset(response: StarRatingModels.Reset.Response)
	func presentSelect(response: StarRatingModels.Select.Response)
}
