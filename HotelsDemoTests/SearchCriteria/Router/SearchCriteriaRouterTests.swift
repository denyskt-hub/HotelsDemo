//
//  SearchCriteriaRouterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 4/7/25.
//

import XCTest
import HotelsDemo

final class SearchCriteriaRouterTests: XCTestCase {
	func test_routeToDestinationPicker_presentsDestinationVC() {
		let container = makeSUT()

		container.sut.routeToDestinationPicker()

		XCTAssertEqual(container.viewController.presentedVC, container.destinationPickerFactory.stub)
	}

	func test_routeToDateRangePicker_presentsDateRangeVC() {
		let container = makeSUT()
		
		container.sut.routeToDateRangePicker(viewModel: .init(startDate: .init(), endDate: .init()))
		
		XCTAssertEqual(container.viewController.presentedVC, container.dateRangePickerFactory.stub)
	}

	func test_routeToRoomGuestsPicker_presentsRoomGuestsVC() {
		let container = makeSUT()
		
		container.sut.routeToRoomGuestsPicker(viewModel: .init(rooms: 1, adults: 1, childrenAge: []))

		XCTAssertEqual(container.viewController.presentedVC, container.roomGuestsPickerFactory.stub)
	}

	// MARK: - Helpers

	private struct SUTContainer {
		let sut: SearchCriteriaRouter
		let viewController: ViewControllerSpy
		let destinationPickerFactory: DestinationPickerFactoryStub
		let dateRangePickerFactory: DateRangePickerFactoryStub
		let roomGuestsPickerFactory: RoomGuestsPickerFactoryStub
	}

	private func makeSUT() -> SUTContainer {
		let viewController = ViewControllerSpy()
		let destinationPickerFactory = DestinationPickerFactoryStub()
		let dateRangePickerFactory = DateRangePickerFactoryStub()
		let roomGuestsPickerFactory = RoomGuestsPickerFactoryStub()
		let sut = SearchCriteriaRouter(
			calendar: .gregorian(),
			destinationPickerFactory: destinationPickerFactory,
			dateRangePickerFactory: dateRangePickerFactory,
			roomGuestsPickerFactory: roomGuestsPickerFactory
		)
		sut.viewController = viewController

		return SUTContainer(
			sut: sut,
			viewController: viewController,
			destinationPickerFactory: destinationPickerFactory,
			dateRangePickerFactory: dateRangePickerFactory,
			roomGuestsPickerFactory: roomGuestsPickerFactory
		)
	}
}

final class ViewControllerSpy: UIViewController {
	var didPresent = false
	var presentedVC: UIViewController?

	override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
		didPresent = true
		presentedVC = viewControllerToPresent
	}
}

final class DestinationPickerFactoryStub: DestinationPickerFactory {
	var stub = UIViewController()

	func makeDestinationPicker(delegate: DestinationPickerDelegate?) -> UIViewController {
		stub
	}
}

final class DateRangePickerFactoryStub: DateRangePickerFactory {
	var stub = UIViewController()

	func makeDateRangePicker(
		delegate: DataRangePickerDelegate?,
		selectedStartDate: Date,
		selectedEndDate: Date,
		calendar: Calendar
	) -> UIViewController {
		stub
	}
}

final class RoomGuestsPickerFactoryStub: RoomGuestsPickerFactory {
	var stub = UIViewController()

	func makeRoomGuestsPicker(
		delegate: RoomGuestsPickerDelegate?,
		rooms: Int,
		adults: Int,
		childrenAge: [Int]
	) -> UIViewController {
		stub
	}
}
