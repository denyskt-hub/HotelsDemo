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

	func test_presentLoadError_displaysCorrectErrorViewModel() {
		let errorMessage = "Some error"
		let expectedViewModel = SearchCriteriaModels.Load.ErrorViewModel(message: errorMessage)
		let (sut, viewController) = makeSUT()

		sut.presentLoadError(TestError(errorMessage))

		XCTAssertEqual(viewController.messages, [.displayLoadError(expectedViewModel)])
	}

	func test_presentDates_displaysCorrectViewModel() {
		let checkInDate = "27.06.2025".date()
		let checkOutDate = "28.06.2025".date()
		let expectedViewModel = DateRangePickerModels.ViewModel(
			startDate: checkInDate,
			endDate: checkOutDate
		)
		let (sut, viewController) = makeSUT()

		sut.presentDates(
			response: SearchCriteriaModels.LoadDates.Response(
				checkInDate: checkInDate,
				checkOutDate: checkOutDate
			)
		)

		XCTAssertEqual(viewController.messages, [.displayDates(expectedViewModel)])
	}

	func test_presentRoomGuests_displaysCorrectViewModel() {
		let roomGuests = RoomGuests(rooms: 1, adults: 2, childrenAge: [])
		let expectedViewModel = RoomGuestsPickerModels.ViewModel(
			rooms: roomGuests.rooms,
			adults: roomGuests.adults,
			childrenAge: roomGuests.childrenAge
		)
		let (sut, viewController) = makeSUT()

		sut.presentRoomGuests(response: SearchCriteriaModels.LoadRoomGuests.Response(roomGuests: roomGuests))

		XCTAssertEqual(viewController.messages, [.displayRoomGuests(expectedViewModel)])
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

struct TestError: Error {
	let message: String

	init(_ message: String) {
		self.message = message
	}
}

extension TestError: LocalizedError {
	var errorDescription: String? { message }
}

final class SearchCriteriaDisplayLogicSpy: SearchCriteriaDisplayLogic {
	enum Message: Equatable {
		case displayCriteria(SearchCriteriaModels.Load.ViewModel)
		case displayLoadError(SearchCriteriaModels.Load.ErrorViewModel)
		case displayDates(DateRangePickerModels.ViewModel)
		case displayRoomGuests(RoomGuestsPickerModels.ViewModel)
	}

	private(set) var messages = [Message]()

	func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel) {
		messages.append(.displayCriteria(viewModel))
	}
	
	func displayLoadError(viewModel: SearchCriteriaModels.Load.ErrorViewModel) {
		messages.append(.displayLoadError(viewModel))
	}
	
	func displayUpdateError(viewModel: SearchCriteriaModels.UpdateDestination.ErrorViewModel) {

	}
	
	func displayDates(viewModel: DateRangePickerModels.ViewModel) {
		messages.append(.displayDates(viewModel))
	}
	
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel) {
		messages.append(.displayRoomGuests(viewModel))
	}
}
