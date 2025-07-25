//
//  ReviewScorePresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol ReviewScorePresentationLogic {
	func present(response: ReviewScoreModels.Load.Response)
	func presentReset(response: ReviewScoreModels.Reset.Response)
	func presentSelect(response: ReviewScoreModels.Select.Response)
}
