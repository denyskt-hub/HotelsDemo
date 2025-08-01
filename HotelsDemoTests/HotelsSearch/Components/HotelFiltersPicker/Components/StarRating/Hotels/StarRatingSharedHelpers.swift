//
//  StarRatingSharedHelpers.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 31/7/25.
//

import Foundation
import HotelsDemo

func oneStarOption(isSelected: Bool = false) -> StarRatingModels.Option {
	makeOption(.one, isSelected: isSelected)
}

func oneStarOptionViewModel(isSelected: Bool = false) -> StarRatingModels.OptionViewModel {
	makeOptionViewModel(.one, isSelected: isSelected)
}

func fiveStarOption(isSelected: Bool = false) -> StarRatingModels.Option {
	makeOption(.five, isSelected: isSelected)
}

func fiveStarOptionViewModel(isSelected: Bool = false) -> StarRatingModels.OptionViewModel {
	makeOptionViewModel(.five, isSelected: isSelected)
}

func makeOption(_ starRating: StarRating, isSelected: Bool) -> StarRatingModels.Option {
	.init(value: starRating, isSelected: isSelected)
}

func makeOptionViewModel(_ starRating: StarRating, isSelected: Bool = false) -> StarRatingModels.OptionViewModel {
	.init(title: starRating.title, value: starRating, isSelected: isSelected)
}
