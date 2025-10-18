//
//  HotelFiltersPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public final class HotelFiltersPickerInteractor: HotelFiltersPickerBusinessLogic {
	private var currentFilters: HotelFilters
	private let presenter: HotelFiltersPickerPresentationLogic

	public init(
		currentFilters: HotelFilters,
		presenter: HotelFiltersPickerPresentationLogic
	) {
		self.currentFilters = currentFilters
		self.presenter = presenter
	}

	public func doFetchFilters(request: HotelFiltersPickerModels.FetchFilters.Request) {
		present(currentFilters)
	}

	public func handlePriceRangeSelection(request: HotelFiltersPickerModels.PriceRangeSelection.Request) {
		currentFilters.priceRange = request.priceRange
		present(currentFilters)
	}

	public func handleStarRatingSelection(request: HotelFiltersPickerModels.StarRatingSelection.Request) {
		currentFilters.starRatings = request.starRatings
		present(currentFilters)
	}

	public func handleReviewScoreSelection(request: HotelFiltersPickerModels.ReviewScoreSelection.Request) {
		currentFilters.reviewScore = request.reviewScore
		present(currentFilters)
	}

	public func handleFilterSelection(request: HotelFiltersPickerModels.FilterSelection.Request) {
		presenter.presentSelectedFilters(response: .init(filters: currentFilters))
	}

	public func handleFilterReset(request: HotelFiltersPickerModels.FilterReset.Request) {
		currentFilters = HotelFilters()
		present(currentFilters)
		presenter.presentResetFilters(response: .init())
	}

	private func present(_ filter: HotelFilters) {
		presenter.present(response: .init(filters: filter))
	}
}
