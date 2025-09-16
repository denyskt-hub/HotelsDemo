//
//  HotelFiltersPickerBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public protocol HotelFiltersPickerBusinessLogic: AnyObject {
	func doFetchFilters(request: HotelFiltersPickerModels.FetchFilters.Request)
	func handlePriceRangeSelection(request: HotelFiltersPickerModels.PriceRangeSelection.Request)
	func handleStarRatingSelection(request: HotelFiltersPickerModels.StarRatingSelection.Request)
	func handleReviewScoreSelection(request: HotelFiltersPickerModels.ReviewScoreSelection.Request)
	func handleFilterSelection(request: HotelFiltersPickerModels.FilterSelection.Request)
	func handleFilterReset(request: HotelFiltersPickerModels.FilterReset.Request)
}
