//
//  HotelsSearchCriteriaViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 6/7/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class HotelsSearchCriteriaViewControllerTests: XCTestCase {
	func test_viewDidLoad_loadInitialData() {
		let (sut, interactor, _, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertEqual(interactor.receivedMessages(), [.doFetchCriteria(.init())])
	}

	func test_destinationButtonTap_routesToDestinationPicker() {
		let (sut, _, router, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateDestinationButtonTap()
		
		XCTAssertEqual(router.messages, [.routeToDestinationPicker])
	}

	func test_datesButtonTap_loadsDates() {
		let (sut, interactor, _, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateDatesButtonTap()

		XCTAssertEqual(interactor.receivedMessages().last, .doFetchDates(.init()))
	}

	func test_roomGuestsButtonTap_loadsRoomGuests() {
		let (sut, interactor, _, _) = makeSUT()
		sut.simulateAppearance()
		
		sut.simulateRoomGuestsButtonTap()

		XCTAssertEqual(interactor.receivedMessages().last, .doFetchRoomGuests(.init()))
	}

	func test_searchButtonTap_requestsSearch() {
		let (sut, interactor, _, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateSearchButtonTap()

		XCTAssertEqual(interactor.receivedMessages().last, .doSearch(.init()))
	}

	func test_displayCriteria_rendersCriteria() {
		let (sut, _, _, _) = makeSUT()

		let anyValidViewModel = anyValidSearchCriteriaViewModel()
		sut.displayCriteria(viewModel: anyValidViewModel)
		assertThat(sut, isRendering: anyValidViewModel)

		let invalidViewModel = invalidSearchCriteriaViewModel()
		sut.displayCriteria(viewModel: invalidViewModel)
		assertThat(sut, isRendering: invalidViewModel)
	}

	func test_displayLoadError_presentsAlertWithCorrectMessage() {
		let (sut, _, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		let viewModel = HotelsSearchCriteriaModels.ErrorViewModel(message: "Failed to load data")
		sut.displayLoadError(viewModel: viewModel)

		XCTAssertEqual(sut.errorMessage, "Failed to load data")
	}

	func test_displayUpdateError_presentsAlertWithCorrectMessage() {
		let (sut, _, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		let viewModel = HotelsSearchCriteriaModels.ErrorViewModel(message: "Failed to load data")
		sut.displayUpdateError(viewModel: viewModel)

		XCTAssertEqual(sut.errorMessage, "Failed to load data")
	}

	func test_displayDates_routesToDateRangePicker() {
		let expectedViewModel = DateRangePickerModels.ViewModel(
			startDate: "06.07.2025".date(),
			endDate: "07.07.2025".date()
		)
		let (sut, _, router, _) = makeSUT()

		sut.displayDates(viewModel: expectedViewModel)

		XCTAssertEqual(router.messages, [.routeToDateRangePicker(expectedViewModel)])
	}

	func test_displayRoomGuests_routesToRoomGuestsPicker() {
		let expectedViewModel = RoomGuestsPickerModels.ViewModel(
			rooms: 1,
			adults: 2,
			childrenAge: [1]
		)
		let (sut, _, router, _) = makeSUT()

		sut.displayRoomGuests(viewModel: expectedViewModel)

		XCTAssertEqual(router.messages, [.routeToRoomGuestsPicker(expectedViewModel)])
	}

	func test_displaySearch_notifiesDelegateWithSearchCriteria() {
		let criteria = anySearchCriteria()
		let (sut, _, _, delegate) = makeSUT()

		sut.displaySearch(viewModel: .init(criteria: criteria))

		XCTAssertEqual(delegate.messages, [.didRequestSearch(criteria)])
	}

	func test_didSelectDestination_updatesDestination() {
		let destination = anyDestination()
		let (sut, interactor, _, _) = makeSUT()

		sut.didSelectDestination(destination)

		XCTAssertEqual(interactor.receivedMessages(), [.handleDestinationSelection(.init(destination: destination))])
	}

	func test_didSelectDateRange_updatesDates() {
		let startDate = "07.07.2025".date()
		let endDate = "08.07.2025".date()
		let (sut, interactor, _, _) = makeSUT()

		sut.didSelectDateRange(startDate: startDate, endDate: endDate)

		XCTAssertEqual(interactor.receivedMessages(), [.handleDateRangeSelection(.init(checkInDate: startDate, checkOutDate: endDate))])
	}

	func test_didSelectRoomGuests_updateRoomGuests() {
		let (rooms, adults, childrenAges) = (1, 2, [1])
		let (sut, interactor, _, _) = makeSUT()

		sut.didSelectRoomGuests(rooms: rooms, adults: adults, childrenAges: childrenAges)

		XCTAssertEqual(interactor.receivedMessages(), [
			.handleRoomGuestsSelection(.init(rooms: rooms, adults: adults, childrenAge: childrenAges))
		])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: HotelsSearchCriteriaViewController,
		interactor: HotelsSearchCriteriaInteractorSpy,
		router: HotelsSearchCriteriaRouterSpy,
		delegate: HotelsSearchCriteriaDelegateSpy
	) {
		let interactor = HotelsSearchCriteriaInteractorSpy()
		let router = HotelsSearchCriteriaRouterSpy()
		let delegate = HotelsSearchCriteriaDelegateSpy()
		let sut = HotelsSearchCriteriaViewController(
			interactor: interactor,
			router: router,
			delegate: delegate
		)
		return (sut, interactor, router, delegate)
	}

	private func assertThat(
		_ sut: HotelsSearchCriteriaViewController,
		isRendering viewModel: HotelsSearchCriteriaModels.FetchCriteria.ViewModel,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		XCTAssertEqual(sut.destinationControlTitle, viewModel.destination, file: file, line: line)
		XCTAssertEqual(sut.datesControlTitle, viewModel.dateRange, file: file, line: line)
		XCTAssertEqual(sut.roomGuestsControlTitle, viewModel.roomGuests, file: file, line: line)
		XCTAssertEqual(sut.searchButton.isEnabled, viewModel.isSearchEnabled, file: file, line: line)
	}

	private func anyValidSearchCriteriaViewModel() -> HotelsSearchCriteriaModels.FetchCriteria.ViewModel {
		.init(
			destination: "Any valid destination",
			dateRange: "Any valid date range",
			roomGuests: "Any valid room guests"
		)
	}

	private func invalidSearchCriteriaViewModel() -> HotelsSearchCriteriaModels.FetchCriteria.ViewModel {
		.init(
			destination: nil,
			dateRange: "Any valid date range",
			roomGuests: "Any valid room guests"
		)
	}
}

extension HotelsSearchCriteriaViewController {
	var errorView: UIAlertController? {
		presentedViewController as? UIAlertController
	}

	var errorMessage: String? {
		errorView?.message
	}

	var destinationControlTitle: String? {
		destinationControl.title()
	}

	var datesControlTitle: String? {
		datesControl.title()
	}

	var roomGuestsControlTitle: String? {
		roomGuestsControl.title()
	}

	func simulateDestinationButtonTap() {
		destinationControl.simulateTap()
	}

	func simulateDatesButtonTap() {
		datesControl.simulateTap()
	}

	func simulateRoomGuestsButtonTap() {
		roomGuestsControl.simulateTap()
	}

	func simulateSearchButtonTap() {
		searchButton.simulateTap()
	}
}

@MainActor
final class HotelsSearchCriteriaInteractorSpy: HotelsSearchCriteriaBusinessLogic {
	enum Message: Equatable {
		case doFetchCriteria(HotelsSearchCriteriaModels.FetchCriteria.Request)
		case doFetchDates(HotelsSearchCriteriaModels.FetchDates.Request)
		case doFetchRoomGuests(HotelsSearchCriteriaModels.FetchRoomGuests.Request)
		case doSearch(HotelsSearchCriteriaModels.Search.Request)
		case handleDestinationSelection(HotelsSearchCriteriaModels.DestinationSelection.Request)
		case handleDateRangeSelection(HotelsSearchCriteriaModels.DateRangeSelection.Request)
		case handleRoomGuestsSelection(HotelsSearchCriteriaModels.RoomGuestsSelection.Request)
	}

	private var messages = [Message]()

	func receivedMessages() -> [Message] {
		messages
	}

	func doFetchCriteria(request: HotelsSearchCriteriaModels.FetchCriteria.Request) {
		messages.append(.doFetchCriteria(request))
	}

	func doFetchDateRange(request: HotelsSearchCriteriaModels.FetchDates.Request) {
		messages.append(.doFetchDates(request))
	}

	func doFetchRoomGuests(request: HotelsSearchCriteriaModels.FetchRoomGuests.Request) {
		messages.append(.doFetchRoomGuests(request))
	}

	func handleDestinationSelection(request: HotelsSearchCriteriaModels.DestinationSelection.Request) {
		messages.append(.handleDestinationSelection(request))
	}

	func handleDateRangeSelection(request: HotelsSearchCriteriaModels.DateRangeSelection.Request) {
		messages.append(.handleDateRangeSelection(request))
	}

	func handleRoomGuestsSelection(request: HotelsSearchCriteriaModels.RoomGuestsSelection.Request) {
		messages.append(.handleRoomGuestsSelection(request))
	}

	func doSearch(request: HotelsSearchCriteriaModels.Search.Request) {
		messages.append(.doSearch(request))
	}
}

final class HotelsSearchCriteriaRouterSpy: HotelsSearchCriteriaRoutingLogic {
	enum Message: Equatable {
		case routeToDestinationPicker
		case routeToDateRangePicker(DateRangePickerModels.ViewModel)
		case routeToRoomGuestsPicker(RoomGuestsPickerModels.ViewModel)
	}

	private(set) var messages = [Message]()

	func routeToDestinationPicker() {
		messages.append(.routeToDestinationPicker)
	}

	func routeToDateRangePicker(viewModel: DateRangePickerModels.ViewModel) {
		messages.append(.routeToDateRangePicker(viewModel))
	}

	func routeToRoomGuestsPicker(viewModel: RoomGuestsPickerModels.ViewModel) {
		messages.append(.routeToRoomGuestsPicker(viewModel))
	}
}

final class HotelsSearchCriteriaDelegateSpy: HotelsSearchCriteriaDelegate {
	enum Message: Equatable {
		case didRequestSearch(HotelsSearchCriteria)
	}

	private(set) var messages = [Message]()

	func didRequestSearch(with searchCriteria: HotelsSearchCriteria) {
		messages.append(.didRequestSearch(searchCriteria))
	}
}
