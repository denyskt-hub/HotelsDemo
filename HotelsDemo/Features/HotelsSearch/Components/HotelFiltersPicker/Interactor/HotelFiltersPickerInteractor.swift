//
//  HotelFiltersPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public final class HotelFiltersPickerInteractor: HotelFiltersPickerBusinessLogic {
	private var currentFilters: HotelFilters

	public var presenter: HotelFiltersPickerPresentationLogic?

	public init(currentFilters: HotelFilters) {
		self.currentFilters = currentFilters
	}

	public func updatePriceRange(request: HotelFiltersPickerModels.UpdatePriceRange.Request) {
		currentFilters.priceRange = request.priceRange
	}

	public func updateStarRatings(request: HotelFiltersPickerModels.UpdateStarRatings.Request) {
		currentFilters.starRatings = request.starRatings
	}

	public func updateReviewScore(request: HotelFiltersPickerModels.UpdateReviewScore.Request) {
		currentFilters.reviewScore = request.reviewScore
	}

	public func selectFilters(request: HotelFiltersPickerModels.Select.Request) {
		presenter?.presentSelectedFilters(response: .init(filters: currentFilters))
	}

	public func resetFilters(request: HotelFiltersPickerModels.Reset.Request) {
		currentFilters = HotelFilters()
		presenter?.presentResetFilters(response: .init())
	}
}
