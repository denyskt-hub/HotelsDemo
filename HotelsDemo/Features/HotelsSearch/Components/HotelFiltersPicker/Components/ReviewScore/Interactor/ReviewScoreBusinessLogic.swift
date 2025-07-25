//
//  ReviewScoreBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol ReviewScoreBusinessLogic {
	func load(request: ReviewScoreModels.Load.Request)
	func reset(request: ReviewScoreModels.Reset.Request)
}
