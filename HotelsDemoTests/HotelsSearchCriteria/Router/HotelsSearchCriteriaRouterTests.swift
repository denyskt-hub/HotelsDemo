//
//  HotelsSearchCriteriaRouterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 4/7/25.
//

import XCTest
import HotelsDemo

final class HotelsSearchCriteriaRouterTests: XCTestCase {
	func test_routeToDestinationPicker_presentsDestinationVC() {
		let container = makeSUT()

		container.sut.routeToDestinationPicker()

		XCTAssertEqual(container.viewController.presentedVC, container.destinationPickerFactory.stub)
	}

	func test_routeToDestinationPicker_buildsPickerWithExpectedDelegate() {
		let container = makeSUT()
		
		container.sut.routeToDestinationPicker()
		
		XCTAssertEqual(container.destinationPickerFactory.messages, [
			.makeDestinationPicker(objectID(container.viewController))
		])
	}

	func test_routeToDateRangePicker_presentsDateRangeVC() {
		let container = makeSUT()
		
		container.sut.routeToDateRangePicker(viewModel: .init(startDate: .init(), endDate: .init()))
		
		XCTAssertEqual(container.viewController.presentedVC, container.dateRangePickerFactory.stub)
	}

	func test_routeToDateRangePicker_buildsPickerWithExpectedDelegateAndParameters() {
		let startDate = "05.07.2025".date()
		let endDate = "06.07.2025".date()
		let container = makeSUT()

		container.sut.routeToDateRangePicker(viewModel: .init(startDate: startDate, endDate: endDate))

		XCTAssertEqual(container.dateRangePickerFactory.messages, [
			.makeDateRangePicker(
				objectID(container.viewController),
				startDate,
				endDate,
				container.calendar
			)
		])
	}

	func test_routeToRoomGuestsPicker_presentsRoomGuestsVC() {
		let container = makeSUT()
		
		container.sut.routeToRoomGuestsPicker(viewModel: .init(rooms: 1, adults: 1, childrenAge: []))

		XCTAssertEqual(container.viewController.presentedVC, container.roomGuestsPickerFactory.stub)
	}

	func test_routeToRoomGuestsPicker_buildsPickerWithExpectedDelegateAndParameters() {
		let (rooms, adults, childrenAge) = (1, 2, [1])
		let container = makeSUT()

		container.sut.routeToRoomGuestsPicker(
			viewModel: .init(rooms: rooms, adults: adults, childrenAge: childrenAge)
		)

		XCTAssertEqual(container.roomGuestsPickerFactory.messages, [
			.makeRoomGuestsPicker(
				objectID(container.viewController),
				rooms,
				adults,
				childrenAge
			)
		])
	}

	// MARK: - Helpers

	private struct SUTContainer {
		let sut: HotelsSearchCriteriaRouter
		let calendar: Calendar
		let destinationPickerFactory: DestinationPickerFactoryStub
		let dateRangePickerFactory: DateRangePickerFactoryStub
		let roomGuestsPickerFactory: RoomGuestsPickerFactoryStub
		let viewController: ViewControllerSpy
	}

	private func makeSUT() -> SUTContainer {
		let calendar = Calendar.gregorian()
		let destinationPickerFactory = DestinationPickerFactoryStub()
		let dateRangePickerFactory = DateRangePickerFactoryStub()
		let roomGuestsPickerFactory = RoomGuestsPickerFactoryStub()
		let viewController = ViewControllerSpy()
		let sut = HotelsSearchCriteriaRouter(
			calendar: calendar,
			destinationPickerFactory: destinationPickerFactory,
			dateRangePickerFactory: dateRangePickerFactory,
			roomGuestsPickerFactory: roomGuestsPickerFactory,
			scene: viewController
		)

		return SUTContainer(
			sut: sut,
			calendar: calendar,
			destinationPickerFactory: destinationPickerFactory,
			dateRangePickerFactory: dateRangePickerFactory,
			roomGuestsPickerFactory: roomGuestsPickerFactory,
			viewController: viewController
		)
	}

	private func delegateID(_ object: AnyObject) -> ObjectIdentifier {
		ObjectIdentifier(object)
	}
}

func objectID(_ object: AnyObject?) -> ObjectIdentifier? {
	object.map { ObjectIdentifier($0) }
}

final class ViewControllerSpy: UIViewController, HotelsSearchCriteriaScene {
	var didPresent = false
	var presentedVC: UIViewController?

	override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
		didPresent = true
		presentedVC = viewControllerToPresent
	}

	func didSelectDestination(_ destination: Destination) {
		// No-op — not needed in this test case
	}

	func didSelectDateRange(startDate: Date, endDate: Date) {
		// No-op — not needed in this test case
	}

	func didSelectRoomGuests(rooms: Int, adults: Int, childrenAges: [Int]) {
		// No-op — not needed in this test case
	}
}

final class DestinationPickerFactoryStub: DestinationPickerFactory {
	enum Message: Equatable {
		case makeDestinationPicker(ObjectIdentifier?)
	}

	var stub = UIViewController()

	private(set) var messages = [Message]()

	func makeDestinationPicker(delegate: DestinationPickerDelegate?) -> UIViewController {
		messages.append(.makeDestinationPicker(objectID(delegate)))
		return stub
	}
}

final class DateRangePickerFactoryStub: DateRangePickerFactory {
	enum Message: Equatable {
		case makeDateRangePicker(ObjectIdentifier?, Date, Date, Calendar)
	}

	var stub = UIViewController()

	private(set) var messages = [Message]()

	func makeDateRangePicker(
		delegate: DateRangePickerDelegate?,
		selectedStartDate: Date,
		selectedEndDate: Date,
		calendar: Calendar
	) -> UIViewController {
		messages.append(
			.makeDateRangePicker(
				objectID(delegate),
				selectedStartDate,
				selectedEndDate,
				calendar
			)
		)
		return stub
	}
}

final class RoomGuestsPickerFactoryStub: RoomGuestsPickerFactory {
	enum Message: Equatable {
		case makeRoomGuestsPicker(ObjectIdentifier?, Int, Int, [Int])
	}

	var stub = UIViewController()

	private(set) var messages = [Message]()

	func makeRoomGuestsPicker(
		delegate: RoomGuestsPickerDelegate?,
		rooms: Int,
		adults: Int,
		childrenAge: [Int]
	) -> UIViewController {
		messages.append(
			.makeRoomGuestsPicker(
				objectID(delegate),
				rooms,
				adults,
				childrenAge
			)
		)
		return stub
	}
}
