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

	}
	
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel) {

	}
}
