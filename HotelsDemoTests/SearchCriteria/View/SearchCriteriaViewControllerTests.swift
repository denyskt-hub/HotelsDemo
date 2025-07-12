//
//  SearchCriteriaViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 6/7/25.
//

import XCTest
import HotelsDemo

final class SearchCriteriaViewControllerTests: XCTestCase {
	func test_viewDidLoad_loadInitialData() {
		let (sut, interactor, _, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertEqual(interactor.messages, [.loadCriteria(.init())])
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

		XCTAssertEqual(interactor.messages.last, .loadDates(.init()))
	}

	func test_roomGuestsButtonTap_loadsRoomGuests() {
		let (sut, interactor, _, _) = makeSUT()
		sut.simulateAppearance()
		
		sut.simulateRoomGuestsButtonTap()

		XCTAssertEqual(interactor.messages.last, .loadRoomGuests(.init()))
	}

	func test_searchButtonTap_requestsSearch() {
		let (sut, interactor, _, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateSearchButtonTap()

		XCTAssertEqual(interactor.messages.last, .search(.init()))
	}

	func test_displayCriteria_rendersCriteria() {
		let (sut, _, _, _) = makeSUT()

		sut.displayCriteria(
			viewModel: .init(
				destination: "destination",
				dateRange: "Jul 10 – Jul 20",
				roomGuests: "2 Adults, 1 Room"
			)
		)

		XCTAssertEqual(sut.destinationControlTitle, "destination")
		XCTAssertEqual(sut.datesControlTitle, "Jul 10 – Jul 20")
		XCTAssertEqual(sut.roomGuestsControlTitle, "2 Adults, 1 Room")
	}

	func test_displayLoadError_presentsAlertWithCorrectMessage() {
		let (sut, _, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		let viewModel = SearchCriteriaModels.ErrorViewModel(message: "Failed to load data")
		sut.displayLoadError(viewModel: viewModel)

		XCTAssertEqual(sut.errorMessage, "Failed to load data")
	}

	func test_displayUpdateError_presentsAlertWithCorrectMessage() {
		let (sut, _, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		let viewModel = SearchCriteriaModels.ErrorViewModel(message: "Failed to load data")
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

		XCTAssertEqual(interactor.messages, [.updateDestination(.init(destination: destination))])
	}

	func test_didSelectDateRange_updatesDates() {
		let startDate = "07.07.2025".date()
		let endDate = "08.07.2025".date()
		let (sut, interactor, _, _) = makeSUT()

		sut.didSelectDateRange(startDate: startDate, endDate: endDate)

		XCTAssertEqual(interactor.messages, [.updateDates(.init(checkInDate: startDate, checkOutDate: endDate))])
	}

	func test_didSelectRoomGuests_updateRoomGuests() {
		let (rooms, adults, childrenAges) = (1, 2, [1])
		let (sut, interactor, _, _) = makeSUT()

		sut.didSelectRoomGuests(rooms: rooms, adults: adults, childrenAges: childrenAges)

		XCTAssertEqual(interactor.messages, [
			.updateRoomGuests(.init(rooms: rooms, adults: adults, childrenAge: childrenAges))
		])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: SearchCriteriaViewController,
		interactor: SearchCriteriaInteractorSpy,
		router: SearchCriteriaRouterSpy,
		delegate: SearchCriteriaDelegateSpy
	) {
		let interactor = SearchCriteriaInteractorSpy()
		let router = SearchCriteriaRouterSpy()
		let delegate = SearchCriteriaDelegateSpy()
		let sut = SearchCriteriaViewController()
		sut.interactor = interactor
		sut.router = router
		sut.delegate = delegate
		return (sut, interactor, router, delegate)
	}
}

extension SearchCriteriaViewController {
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

final class SearchCriteriaInteractorSpy: SearchCriteriaBusinessLogic {
	enum Message: Equatable {
		case loadCriteria(SearchCriteriaModels.Load.Request)
		case loadDates(SearchCriteriaModels.LoadDates.Request)
		case loadRoomGuests(SearchCriteriaModels.LoadRoomGuests.Request)
		case updateDestination(SearchCriteriaModels.UpdateDestination.Request)
		case updateDates(SearchCriteriaModels.UpdateDates.Request)
		case updateRoomGuests(SearchCriteriaModels.UpdateRoomGuests.Request)
		case search(SearchCriteriaModels.Search.Request)
	}

	private(set) var messages = [Message]()

	func loadCriteria(request: SearchCriteriaModels.Load.Request) {
		messages.append(.loadCriteria(request))
	}

	func loadDates(request: SearchCriteriaModels.LoadDates.Request) {
		messages.append(.loadDates(request))
	}

	func loadRoomGuests(request: SearchCriteriaModels.LoadRoomGuests.Request) {
		messages.append(.loadRoomGuests(request))
	}

	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request) {
		messages.append(.updateDestination(request))
	}

	func updateDates(request: SearchCriteriaModels.UpdateDates.Request) {
		messages.append(.updateDates(request))
	}

	func updateRoomGuests(request: SearchCriteriaModels.UpdateRoomGuests.Request) {
		messages.append(.updateRoomGuests(request))
	}

	func search(request: SearchCriteriaModels.Search.Request) {
		messages.append(.search(request))
	}
}

final class SearchCriteriaRouterSpy: SearchCriteriaRoutingLogic {
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

final class SearchCriteriaDelegateSpy: SearchCriteriaDelegate {
	enum Message: Equatable {
		case didRequestSearch(SearchCriteria)
	}

	private(set) var messages = [Message]()

	func didRequestSearch(with searchCriteria: SearchCriteria) {
		messages.append(.didRequestSearch(searchCriteria))
	}
}

extension UIViewController {
	func simulateAppearance() {
		if !isViewLoaded {
			loadViewIfNeeded()
		}

		beginAppearanceTransition(true, animated: false)
		endAppearanceTransition()
	}

	func simulateAppearanceInWindow() {
		putInWindow(self)
		simulateAppearance()
	}

	@discardableResult
	func putInWindow(_ viewController: UIViewController) -> UIWindow {
		let window = UIWindow(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
		window.rootViewController = viewController
		window.isHidden = false
		waitForPresentation()
		return window
	}

	func waitForPresentation(timeout: TimeInterval = 0.1) {
		RunLoop.current.run(until: Date().addingTimeInterval(timeout))
	}
}

extension UIControl {
	func simulateTap() {
		simulate(event: .touchUpInside)
	}

	func simulate(event: UIControl.Event) {
		allTargets.forEach { target in
			actions(forTarget: target, forControlEvent: event)?.forEach {
				(target as NSObject).perform(Selector($0))
			}
		}
	}
}
