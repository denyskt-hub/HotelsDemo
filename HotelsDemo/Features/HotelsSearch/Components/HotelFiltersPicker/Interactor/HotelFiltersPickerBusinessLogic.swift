//
//  HotelFiltersPickerBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol HotelFiltersPickerBusinessLogic: AnyObject {
	func updatePriceRange(request: HotelFiltersPickerModels.UpdatePriceRange.Request)
	func updateStarRatings(request: HotelFiltersPickerModels.UpdateStarRatings.Request)
	func updateReviewScore(request: HotelFiltersPickerModels.UpdateReviewScore.Request)
	func selectFilter(request: HotelFiltersPickerModels.Select.Request)
	func resetFilter(request: HotelFiltersPickerModels.Reset.Request)
}
