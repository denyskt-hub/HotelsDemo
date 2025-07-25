//
//  ReviewScoreDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol ReviewScoreDisplayLogic: AnyObject {
	func display(viewModel: ReviewScoreModels.Load.ViewModel)
	func displayReset(viewModel: ReviewScoreModels.Reset.ViewModel)
}
