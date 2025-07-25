//
//  HotelFiltersPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public final class HotelFiltersPickerInteractor: HotelFiltersPickerBusinessLogic {
	private var currentFilter: HotelsFilter

	public var presenter: HotelFiltersPickerPresentationLogic?

	public init(currentFilter: HotelsFilter) {
		self.currentFilter = currentFilter
	}

	public func updatePriceRange(request: HotelFiltersPickerModels.UpdatePriceRange.Request) {
		currentFilter.priceRange = request.priceRange
	}

	public func updateStarRatings(request: HotelFiltersPickerModels.UpdateStarRatings.Request) {
		currentFilter.starRatings = request.starRatings
	}

	public func updateReviewScore(request: HotelFiltersPickerModels.UpdateReviewScore.Request) {
		currentFilter.reviewScores = request.reviewScores
	}

	public func selectFilter(request: HotelFiltersPickerModels.Select.Request) {
		presenter?.presentSelectedFilter(response: .init(filter: currentFilter))
	}

	public func resetFilter(request: HotelFiltersPickerModels.Reset.Request) {
		currentFilter = HotelsFilter()
		presenter?.presentResetFilter(response: .init())
	}
}
