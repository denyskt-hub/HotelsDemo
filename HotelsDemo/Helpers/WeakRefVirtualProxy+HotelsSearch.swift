//
//  WeakRefVirtualProxy+HotelsSearch.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/10/25.
//

import Foundation

// MARK: - HotelsSearchScene

extension WeakRefVirtualProxy: HotelsSearchScene where T: HotelsSearchScene {}

extension WeakRefVirtualProxy: HotelFiltersPickerDelegate where T: HotelFiltersPickerDelegate {
	public func didSelectFilters(_ filters: HotelFilters) {
		object?.didSelectFilters(filters)
	}
}

// MARK: - HotelsSearchDisplayLogic

extension WeakRefVirtualProxy: HotelsSearchDisplayLogic where T: HotelsSearchDisplayLogic {
	public func displaySearch(viewModel: HotelsSearchModels.Search.ViewModel) {
		object?.displaySearch(viewModel: viewModel)
	}

	public func displayLoading(viewModel: HotelsSearchModels.LoadingViewModel) {
		object?.displayLoading(viewModel: viewModel)
	}

	public func displaySearchError(viewModel: HotelsSearchModels.ErrorViewModel) {
		object?.displaySearchError(viewModel: viewModel)
	}

	public func displayFilters(viewModel: HotelsSearchModels.FetchFilters.ViewModel) {
		object?.displayFilters(viewModel: viewModel)
	}

	public func displayUpdateFilters(viewModel: HotelsSearchModels.FilterSelection.ViewModel) {
		object?.displayUpdateFilters(viewModel: viewModel)
	}
}

// MARK: - HotelsDisplayLogic

extension WeakRefVirtualProxy: HotelsDisplayLogic where T: HotelsDisplayLogic {
	public func displayCellControllers(_ cellControllers: [HotelCellController]) {
		object?.displayCellControllers(cellControllers)
	}

	public func displayFiltersBadge(_ isBadgeVisible: Bool) {
		object?.displayFiltersBadge(isBadgeVisible)
	}

	public func displayLoading(_ isLoading: Bool) {
		object?.displayLoading(isLoading)
	}

	public func displayErrorMessage(_ message: String) {
		object?.displayErrorMessage(message)
	}

	public func displayFilters(_ filters: HotelFilters) {
		object?.displayFilters(filters)
	}
}

// MARK: - HotelFiltersScene

extension WeakRefVirtualProxy: HotelFiltersScene where T: HotelFiltersScene {}

extension WeakRefVirtualProxy: PriceRangeDelegate where T: PriceRangeDelegate {
	public func didSelectPriceRange(_ priceRange: ClosedRange<Decimal>?) {
		object?.didSelectPriceRange(priceRange)
	}
}

extension WeakRefVirtualProxy: StarRatingDelegate where T: StarRatingDelegate {
	public func didSelectStarRatings(_ starRatings: Set<StarRating>) {
		object?.didSelectStarRatings(starRatings)
	}
}

extension WeakRefVirtualProxy: ReviewScoreDelegate where T: ReviewScoreDelegate {
	public func didSelectReviewScore(_ reviewScore: ReviewScore?) {
		object?.didSelectReviewScore(reviewScore)
	}
}

// MARK: - HotelFiltersPickerDisplayLogic

extension WeakRefVirtualProxy: HotelFiltersPickerDisplayLogic where T: HotelFiltersPickerDisplayLogic {
	public func display(viewModel: HotelFiltersPickerModels.FetchFilters.ViewModel) {
		object?.display(viewModel: viewModel)
	}

	public func displaySelectedFilters(viewModel: HotelFiltersPickerModels.FilterSelection.ViewModel) {
		object?.displaySelectedFilters(viewModel: viewModel)
	}

	public func displayResetFilters(viewModel: HotelFiltersPickerModels.FilterReset.ViewModel) {
		object?.displayResetFilters(viewModel: viewModel)
	}
}

// MARK: - PriceRangeDisplayLogic

extension WeakRefVirtualProxy: PriceRangeDisplayLogic where T: PriceRangeDisplayLogic {
	public func display(viewModel: PriceRangeModels.FetchPriceRange.ViewModel) {
		object?.display(viewModel: viewModel)
	}

	public func displayReset(viewModel: PriceRangeModels.PriceRangeReset.ViewModel) {
		object?.displayReset(viewModel: viewModel)
	}

	public func displaySelect(viewModel: PriceRangeModels.PriceRangeSelection.ViewModel) {
		object?.displaySelect(viewModel: viewModel)
	}

	public func displaySelecting(viewModel: PriceRangeModels.SelectingPriceRange.ViewModel) {
		object?.displaySelecting(viewModel: viewModel)
	}
}

// MARK: - StarRatingDisplayLogic

extension WeakRefVirtualProxy: StarRatingDisplayLogic where T: StarRatingDisplayLogic {
	public func display(viewModel: StarRatingModels.FetchStarRating.ViewModel) {
		object?.display(viewModel: viewModel)
	}

	public func displayReset(viewModel: StarRatingModels.StarRatingReset.ViewModel) {
		object?.displayReset(viewModel: viewModel)
	}

	public func displaySelect(viewModel: StarRatingModels.StarRatingSelection.ViewModel) {
		object?.displaySelect(viewModel: viewModel)
	}
}

// MARK: - ReviewScoreDisplayLogic

extension WeakRefVirtualProxy: ReviewScoreDisplayLogic where T: ReviewScoreDisplayLogic {
	public func display(viewModel: ReviewScoreModels.FetchReviewScore.ViewModel) {
		object?.display(viewModel: viewModel)
	}

	public func displayReset(viewModel: ReviewScoreModels.ReviewScoreReset.ViewModel) {
		object?.displayReset(viewModel: viewModel)
	}

	public func displaySelect(viewModel: ReviewScoreModels.ReviewScoreSelection.ViewModel) {
		object?.displaySelect(viewModel: viewModel)
	}
}
