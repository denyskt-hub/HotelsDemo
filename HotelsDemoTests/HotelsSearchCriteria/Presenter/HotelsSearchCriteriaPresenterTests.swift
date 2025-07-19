//
//  HotelsSearchCriteriaPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/6/25.
//

import XCTest
import HotelsDemo

final class HotelsSearchCriteriaPresenterTests: XCTestCase {
	func test_presentLoadCriteria_displaysCorrectViewModelForGivenCriteria() {
		let criteria = HotelsSearchCriteria(
			destination: nil,
			checkInDate: "27.06.2025".date(),
			checkOutDate: "28.06.2025".date(),
			adults: 2,
			childrenAge: [3],
			roomsQuantity: 1
		)
		let expectedViewModel = HotelsSearchCriteriaModels.Load.ViewModel(
			destination: nil,
			dateRange: "27 Jun – 28 Jun",
			roomGuests: "1 room for 2 adults, 1 child"
		)
		let (sut, viewController) = makeSUT()

		sut.presentLoadCriteria(response: HotelsSearchCriteriaModels.Load.Response(criteria: criteria))

		XCTAssertEqual(viewController.messages, [.displayCriteria(expectedViewModel)])
	}

	func test_presentLoadError_displaysCorrectErrorViewModel() {
		let errorMessage = "Some error"
		let expectedViewModel = HotelsSearchCriteriaModels.ErrorViewModel(message: errorMessage)
		let (sut, viewController) = makeSUT()

		sut.presentLoadError(TestError(errorMessage))

		XCTAssertEqual(viewController.messages, [.displayLoadError(expectedViewModel)])
	}

	func test_presentUpdateError_displaysCorrectErrorViewModel() {
		let errorMessage = "Some error"
		let expectedViewModel = HotelsSearchCriteriaModels.ErrorViewModel(message: errorMessage)
		let (sut, viewController) = makeSUT()

		sut.presentUpdateError(TestError(errorMessage))

		XCTAssertEqual(viewController.messages, [.displayUpdateError(expectedViewModel)])
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
			response: HotelsSearchCriteriaModels.LoadDates.Response(
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

		sut.presentRoomGuests(response: HotelsSearchCriteriaModels.LoadRoomGuests.Response(roomGuests: roomGuests))

		XCTAssertEqual(viewController.messages, [.displayRoomGuests(expectedViewModel)])
	}

	func test_presentUpdateDestination_displaysCorrectViewModel() {
		let criteria = makeSearchCriteria(
			destination: makeDestination(label: "London"),
			checkInDate: "27.06.2025".date(),
			checkOutDate: "28.06.2025".date(),
			adults: 2,
			childrenAge: [3],
			roomsQuantity: 1
		)
		let expectedViewModel = HotelsSearchCriteriaModels.Load.ViewModel(
			destination: "London",
			dateRange: "27 Jun – 28 Jun",
			roomGuests: "1 room for 2 adults, 1 child"
		)
		let (sut, viewController) = makeSUT()

		sut.presentUpdateDestination(response: HotelsSearchCriteriaModels.UpdateDestination.Response(criteria: criteria))

		XCTAssertEqual(viewController.messages, [.displayCriteria(expectedViewModel)])
	}

	func test_presentUpdateDates_displaysCorrectViewModel() {
		let criteria = makeSearchCriteria(
			destination: nil,
			checkInDate: "10.07.2025".date(),
			checkOutDate: "15.07.2025".date(),
			adults: 3,
			childrenAge: [],
			roomsQuantity: 2
		)
		let expectedViewModel = HotelsSearchCriteriaModels.Load.ViewModel(
			destination: nil,
			dateRange: "10 Jul – 15 Jul",
			roomGuests: "2 rooms for 3 adults"
		)
		let (sut, viewController) = makeSUT()

		sut.presentUpdateDates(response: HotelsSearchCriteriaModels.UpdateDates.Response(criteria: criteria))

		XCTAssertEqual(viewController.messages, [.displayCriteria(expectedViewModel)])
	}

	func test_presentUpdateRoomGuests_displaysCorrectViewModel() {
		let criteria = makeSearchCriteria(
			destination: makeDestination(label: "New York, USA"),
			checkInDate: "22.08.2025".date(),
			checkOutDate: "23.08.2025".date(),
			adults: 1,
			childrenAge: [0],
			roomsQuantity: 1
		)
		let expectedViewModel = HotelsSearchCriteriaModels.Load.ViewModel(
			destination: "New York, USA",
			dateRange: "22 Aug – 23 Aug",
			roomGuests: "1 room for 1 adult, 1 child"
		)
		let (sut, viewController) = makeSUT()

		sut.presentUpdateRoomGuests(response: HotelsSearchCriteriaModels.UpdateRoomGuests.Response(criteria: criteria))

		XCTAssertEqual(viewController.messages, [.displayCriteria(expectedViewModel)])
	}

	func test_presentSearch_displaysSearch() {
		let criteria = anySearchCriteria()
		let (sut, viewController) = makeSUT()

		sut.presentSearch(response: .init(criteria: criteria))

		XCTAssertEqual(viewController.messages, [.displaySearch(.init(criteria: criteria))])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: HotelsSearchCriteriaPresenter,
		viewController: HotelsSearchCriteriaDisplayLogicSpy
	) {
		let viewController = HotelsSearchCriteriaDisplayLogicSpy()
		let sut = HotelsSearchCriteriaPresenter(calendar: .gregorian())
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

final class HotelsSearchCriteriaDisplayLogicSpy: HotelsSearchCriteriaDisplayLogic {
	enum Message: Equatable {
		case displayCriteria(HotelsSearchCriteriaModels.Load.ViewModel)
		case displayLoadError(HotelsSearchCriteriaModels.ErrorViewModel)
		case displayUpdateError(HotelsSearchCriteriaModels.ErrorViewModel)
		case displayDates(DateRangePickerModels.ViewModel)
		case displayRoomGuests(RoomGuestsPickerModels.ViewModel)
		case displaySearch(HotelsSearchCriteriaModels.Search.ViewModel)
	}

	private(set) var messages = [Message]()

	func displayCriteria(viewModel: HotelsSearchCriteriaModels.Load.ViewModel) {
		messages.append(.displayCriteria(viewModel))
	}

	func displayLoadError(viewModel: HotelsSearchCriteriaModels.ErrorViewModel) {
		messages.append(.displayLoadError(viewModel))
	}

	func displayUpdateError(viewModel: HotelsSearchCriteriaModels.ErrorViewModel) {
		messages.append(.displayUpdateError(viewModel))
	}

	func displayDates(viewModel: DateRangePickerModels.ViewModel) {
		messages.append(.displayDates(viewModel))
	}

	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel) {
		messages.append(.displayRoomGuests(viewModel))
	}

	func displaySearch(viewModel: HotelsSearchCriteriaModels.Search.ViewModel) {
		messages.append(.displaySearch(viewModel))
	}
}
