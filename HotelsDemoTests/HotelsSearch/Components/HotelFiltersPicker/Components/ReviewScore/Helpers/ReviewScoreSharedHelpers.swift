//
//  ReviewScoreSharedHelpers.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 30/7/25.
//

import Foundation
import HotelsDemo

func fairOption(isSelected: Bool = false) -> ReviewScoreModels.Option {
	makeOption(.fair, isSelected: isSelected)
}

func fairOptionViewModel(isSelected: Bool = false) -> ReviewScoreModels.OptionViewModel {
	.init(title: ReviewScore.fair.title, value: .fair, isSelected: isSelected)
}

func wonderfulOption(isSelected: Bool = false) -> ReviewScoreModels.Option {
	makeOption(.wonderful, isSelected: isSelected)
}

func wonderfulOptionViewModel(isSelected: Bool = false) -> ReviewScoreModels.OptionViewModel {
	.init(title: ReviewScore.wonderful.title, value: .wonderful, isSelected: isSelected)
}

func makeOption(_ reviewScore: ReviewScore, isSelected: Bool) -> ReviewScoreModels.Option {
	.init(value: reviewScore, isSelected: isSelected)
}

func makeOptionViewModel(_ reviewScore: ReviewScore, isSelected: Bool = false) -> ReviewScoreModels.OptionViewModel {
	.init(title: reviewScore.title, value: reviewScore, isSelected: isSelected)
}
