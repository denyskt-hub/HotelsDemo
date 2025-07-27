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
	func selectFilters(request: HotelFiltersPickerModels.Select.Request)
	func resetFilters(request: HotelFiltersPickerModels.Reset.Request)
}
