//
//  WeakRefVirtualProxy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit
import Foundation

public final class WeakRefVirtualProxy<T: AnyObject> {
	public weak var object: T?

	public init(object: T? = nil) {
		self.object = object
	}
}

extension WeakRefVirtualProxy: Routable where T: Routable {
	public func present(_ viewController: UIViewController) {
		object?.present(viewController)
	}

	public func show(_ viewController: UIViewController) {
		object?.show(viewController)
	}
}

extension WeakRefVirtualProxy: MainDisplayLogic where T: MainDisplayLogic {
	public func displaySearch(viewModel: MainModels.Search.ViewModel) {
		object?.displaySearch(viewModel: viewModel)
	}
}

extension WeakRefVirtualProxy: HotelsSearchCriteriaDelegate where T: HotelsSearchCriteriaDelegate {
	public func didRequestSearch(with searchCriteria: HotelsSearchCriteria) {
		object?.didRequestSearch(with: searchCriteria)
	}
}

extension WeakRefVirtualProxy: HotelsSearchCriteriaDisplayLogic where T: HotelsSearchCriteriaDisplayLogic {
	public func displayCriteria(viewModel: HotelsSearchCriteriaModels.FetchCriteria.ViewModel) {
		object?.displayCriteria(viewModel: viewModel)
	}

	public func displayLoadError(viewModel: HotelsSearchCriteriaModels.ErrorViewModel) {
		object?.displayLoadError(viewModel: viewModel)
	}

	public func displayUpdateError(viewModel: HotelsSearchCriteriaModels.ErrorViewModel) {
		object?.displayUpdateError(viewModel: viewModel)
	}

	public func displayDates(viewModel: DateRangePickerModels.ViewModel) {
		object?.displayDates(viewModel: viewModel)
	}

	public func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel) {
		object?.displayRoomGuests(viewModel: viewModel)
	}

	public func displaySearch(viewModel: HotelsSearchCriteriaModels.Search.ViewModel) {
		object?.displaySearch(viewModel: viewModel)
	}
}

extension WeakRefVirtualProxy: DateRangePickerDisplayLogic where T: DateRangePickerDisplayLogic {
	public func display(viewModel: DateRangePickerModels.FetchCalendar.ViewModel) {
		object?.display(viewModel: viewModel)
	}

	public func displaySelectDate(viewModel: DateRangePickerModels.DateSelection.ViewModel) {
		object?.displaySelectDate(viewModel: viewModel)
	}

	public func displaySelectedDateRange(viewModel: DateRangePickerModels.DateRangeSelection.ViewModel) {
		object?.displaySelectedDateRange(viewModel: viewModel)
	}
}

extension WeakRefVirtualProxy: DestinationPickerDisplayLogic where T: DestinationPickerDisplayLogic {
	public func displayDestinations(viewModel: DestinationPickerModels.Search.ViewModel) {
		object?.displayDestinations(viewModel: viewModel)
	}

	public func displaySelectedDestination(viewModel: DestinationPickerModels.DestinationSelection.ViewModel) {
		object?.displaySelectedDestination(viewModel: viewModel)
	}

	public func displaySearchError(viewModel: DestinationPickerModels.Search.ErrorViewModel) {
		object?.displaySearchError(viewModel: viewModel)
	}

	public func hideSearchError() {
		object?.hideSearchError()
	}
}

extension WeakRefVirtualProxy: RoomGuestsPickerDisplayLogic where T: RoomGuestsPickerDisplayLogic {
	public func applyLimits(_ limits: RoomGuestsLimits) {
		object?.applyLimits(limits)
	}

	public func displayRoomGuests(viewModel: RoomGuestsPickerModels.FetchRoomGuests.ViewModel) {
		object?.displayRoomGuests(viewModel: viewModel)
	}

	public func displayRooms(viewModel: RoomGuestsPickerModels.UpdateRooms.ViewModel) {
		object?.displayRooms(viewModel: viewModel)
	}

	public func displayAdults(viewModel: RoomGuestsPickerModels.UpdateAdults.ViewModel) {
		object?.displayAdults(viewModel: viewModel)
	}

	public func displayUpdateChildrenAge(viewModel: RoomGuestsPickerModels.UpdateChildrenAge.ViewModel) {
		object?.displayUpdateChildrenAge(viewModel: viewModel)
	}

	public func displayAgePicker(viewModel: RoomGuestsPickerModels.AgeSelection.ViewModel) {
		object?.displayAgePicker(viewModel: viewModel)
	}

	public func displayChildrenAge(viewModel: RoomGuestsPickerModels.AgeSelected.ViewModel) {
		object?.displayChildrenAge(viewModel: viewModel)
	}

	public func displaySelectedRoomGuests(viewModel: RoomGuestsPickerModels.Select.ViewModel) {
		object?.displaySelectedRoomGuests(viewModel: viewModel)
	}
}

// MARK: - HotelsSearchCriteriaScene

extension WeakRefVirtualProxy: HotelsSearchCriteriaScene where T: HotelsSearchCriteriaScene {}

extension WeakRefVirtualProxy: DestinationPickerDelegate where T: DestinationPickerDelegate {
	public func didSelectDestination(_ destination: Destination) {
		object?.didSelectDestination(destination)
	}
}

extension WeakRefVirtualProxy: DateRangePickerDelegate where T: DateRangePickerDelegate {
	public func didSelectDateRange(startDate: Date, endDate: Date) {
		object?.didSelectDateRange(startDate: startDate, endDate: endDate)
	}
}

extension WeakRefVirtualProxy: RoomGuestsPickerDelegate where T: RoomGuestsPickerDelegate {
	public func didSelectRoomGuests(rooms: Int, adults: Int, childrenAges: [Int]) {
		object?.didSelectRoomGuests(rooms: rooms, adults: adults, childrenAges: childrenAges)
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
