//
//  RoomGuestsPickerPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 1/7/25.
//

import XCTest
import HotelsDemo

final class RoomGuestsPickerPresenterTests: XCTestCase {
	func test_presentLimits_appliesLimits() {
		let expectedLimits = anyRoomGuestsLimits()
		let (sut, viewController) = makeSUT()

		sut.presentLimits(response: .init(limits: expectedLimits))

		XCTAssertEqual(viewController.messages, [.applyLimits(expectedLimits)])
	}

	typealias RoomGuests = (rooms: Int, adults: Int, childrenAge: [Int])

	func test_presentRoomGuests_displaysRoomGuests() {
		let (rooms, adults, childrenAge) = RoomGuests(1, 1, [1])
		let expectedChildrenAge = [
			RoomGuestsPickerModels.AgeInputViewModel(
				index: 0,
				title: "Child 1",
				selectedAgeTitle: "1 year old"
			)
		]
		let (sut, viewController) = makeSUT()

		sut.presentRoomGuests(response: .init(rooms: rooms, adults: adults, childrenAge: childrenAge))

		XCTAssertEqual(viewController.messages, [
			.displayRoomGuests(
				.init(rooms: rooms, adults: adults, childrenAge: expectedChildrenAge)
			)
		])
	}

	func test_presentUpdateRooms_displaysRooms() {
		let rooms = 2
		let (sut, viewController) = makeSUT()

		sut.presentUpdateRooms(response: .init(rooms: rooms))

		XCTAssertEqual(viewController.messages, [.displayRooms(.init(rooms: rooms))])
	}

	func test_presentUpdateAdults_displaysAdults() {
		let adults = 2
		let (sut, viewController) = makeSUT()

		sut.presentUpdateAdults(response: .init(adults: adults))

		XCTAssertEqual(viewController.messages, [.displayAdults(.init(adults: adults))])
	}

	func test_presentUpdateChildrenAge_displaysUpdateChildrenAge() {
		let childrenAge = [2]
		let expectedChildrenAge = [
			RoomGuestsPickerModels.AgeInputViewModel(
				index: 0,
				title: "Child 1",
				selectedAgeTitle: "2 years old"
			)
		]
		let (sut, viewController) = makeSUT()

		sut.presentUpdateChildrenAge(response: .init(childrenAge: childrenAge))

		XCTAssertEqual(viewController.messages, [
			.displayUpdateChildrenAge(.init(childrenAge: expectedChildrenAge))
		])
	}

	func test_presentAgePicker_displaysAgePicker() {
		let index = 0
		let selectedAge = 2
		let availableAges = [1, 2, 3]
		let expectedViewModel = RoomGuestsPickerModels.AgeSelection.ViewModel(
			index: index,
			title: "Child 1",
			selectedIndex: 1,
			availableAges: [
				.init(value: 1, title: "1 year old"),
				.init(value: 2, title: "2 years old"),
				.init(value: 3, title: "3 years old")
			]
		)
		let (sut, viewController) = makeSUT()

		sut.presentAgePicker(response: .init(index: index, availableAges: availableAges, selectedAge: selectedAge))

		XCTAssertEqual(viewController.messages, [.displayAgePicker(expectedViewModel)])
	}

	func test_presentChildrenAge_displaysChildrenAge() {
		let childrenAge = [5]
		let expectedChildrenAge = [
			RoomGuestsPickerModels.AgeInputViewModel(
				index: 0,
				title: "Child 1",
				selectedAgeTitle: "5 years old"
			)
		]
		let (sut, viewController) = makeSUT()

		sut.presentChildrenAge(response: .init(childrenAge: childrenAge))

		XCTAssertEqual(viewController.messages, [.displayChildrenAge(.init(childrenAge: expectedChildrenAge))])
	}

	func test_presentSelectedRoomGuests_displaysSelectedRoomGuests() {
		let (rooms, adults, childrenAge) = RoomGuests(1, 1, [1])
		let (sut, viewController) = makeSUT()

		sut.presentSelectedRoomGuests(response: .init(rooms: rooms, adults: adults, childrenAge: childrenAge))

		XCTAssertEqual(viewController.messages, [
			.displaySelectedRoomGuests(.init(rooms: rooms, adults: adults, childrenAge: childrenAge))
		])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: RoomGuestsPickerPresenter,
		viewController: RoomGuestsPickerDisplayLogicSpy
	) {
		let viewController = RoomGuestsPickerDisplayLogicSpy()
		let sut = RoomGuestsPickerPresenter(
			viewController: viewController
		)
		return (sut, viewController)
	}

	private func anyRoomGuestsLimits() -> RoomGuestsLimits {
		.init(maxRooms: 1, maxAdults: 1, maxChildren: 1)
	}
}

final class RoomGuestsPickerDisplayLogicSpy: RoomGuestsPickerDisplayLogic {
	enum Message: Equatable {
		case applyLimits(RoomGuestsLimits)
		case displayRoomGuests(RoomGuestsPickerModels.FetchRoomGuests.ViewModel)
		case displayRooms(RoomGuestsPickerModels.UpdateRooms.ViewModel)
		case displayAdults(RoomGuestsPickerModels.UpdateAdults.ViewModel)
		case displayUpdateChildrenAge(RoomGuestsPickerModels.UpdateChildrenAge.ViewModel)
		case displayAgePicker(RoomGuestsPickerModels.AgeSelection.ViewModel)
		case displayChildrenAge(RoomGuestsPickerModels.AgeSelected.ViewModel)
		case displaySelectedRoomGuests(RoomGuestsPickerModels.Select.ViewModel)
	}

	private(set) var messages = [Message]()

	func applyLimits(_ limits: RoomGuestsLimits) {
		messages.append(.applyLimits(limits))
	}
	
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.FetchRoomGuests.ViewModel) {
		messages.append(.displayRoomGuests(viewModel))
	}
	
	func displayRooms(viewModel: RoomGuestsPickerModels.UpdateRooms.ViewModel) {
		messages.append(.displayRooms(viewModel))
	}
	
	func displayAdults(viewModel: RoomGuestsPickerModels.UpdateAdults.ViewModel) {
		messages.append(.displayAdults(viewModel))
	}
	
	func displayUpdateChildrenAge(viewModel: RoomGuestsPickerModels.UpdateChildrenAge.ViewModel) {
		messages.append(.displayUpdateChildrenAge(viewModel))
	}
	
	func displayAgePicker(viewModel: RoomGuestsPickerModels.AgeSelection.ViewModel) {
		messages.append(.displayAgePicker(viewModel))
	}
	
	func displayChildrenAge(viewModel: RoomGuestsPickerModels.AgeSelected.ViewModel) {
		messages.append(.displayChildrenAge(viewModel))
	}
	
	func displaySelectedRoomGuests(viewModel: RoomGuestsPickerModels.Select.ViewModel) {
		messages.append(.displaySelectedRoomGuests(viewModel))
	}
}
