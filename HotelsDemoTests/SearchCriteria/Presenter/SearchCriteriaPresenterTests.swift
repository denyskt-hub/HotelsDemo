//
//  SearchCriteriaPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/6/25.
//

import XCTest
import HotelsDemo

final class SearchCriteriaPresenterTests: XCTestCase {
	func test_presentLoadCriteria_displaysCorrectViewModelForGivenCriteria() {
		let criteria = SearchCriteria(
			destination: nil,
			checkInDate: "27.06.2025".date(),
			checkOutDate: "28.06.2025".date(),
			adults: 2,
			childrenAge: [3],
			roomsQuantity: 1
		)
		let expectedViewModel = SearchCriteriaModels.Load.ViewModel(
			destination: nil,
			dateRange: "27 Jun – 28 Jun",
			roomGuests: "1 room for 2 adults, 1 child"
		)
		let (sut, viewController) = makeSUT()

		sut.presentLoadCriteria(response: SearchCriteriaModels.Load.Response(criteria: criteria))

		XCTAssertEqual(viewController.messages, [.displayCriteria(expectedViewModel)])
	}
	
	// MARK: - Helpers

	private func makeSUT() -> (
		sut: SearchCriteriaPresenter,
		viewController: SearchCriteriaDisplayLogicSpy
	) {
		let viewController = SearchCriteriaDisplayLogicSpy()
		let sut = SearchCriteriaPresenter(calendar: .gregorian())
		sut.viewController = viewController
		return (sut, viewController)
	}
}

final class SearchCriteriaDisplayLogicSpy: SearchCriteriaDisplayLogic {
	enum Message: Equatable {
		case displayCriteria(SearchCriteriaModels.Load.ViewModel)
	}

	private(set) var messages = [Message]()

	func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel) {
		messages.append(.displayCriteria(viewModel))
	}
	
	func displayLoadError(viewModel: SearchCriteriaModels.Load.ErrorViewModel) {

	}
	
	func displayUpdateError(viewModel: SearchCriteriaModels.UpdateDestination.ErrorViewModel) {

	}
	
	func displayDates(viewModel: DateRangePickerModels.ViewModel) {

	}
	
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel) {

	}
}
