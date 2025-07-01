//
//  RoomGuestsPickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 1/7/25.
//

import XCTest
import HotelsDemo

final class RoomGuestsPickerInteractorTests: XCTestCase {
	let limits = RoomGuestsLimits(maxRooms: 30, maxAdults: 30, maxChildren: 10)
	let availableAges = Array(0...17)

	func test_loadLimits_presentsLimits() {
		let (sut, presenter) = makeSUT()

		sut.loadLimits(request: .init())

		XCTAssertEqual(presenter.messages, [.presentLimits(.init(limits: limits))])
	}

	func test_load_presentsRoomGuests() {
		let rooms = 2
		let adults = 2
		let childrenAge = [4, 2]
		let (sut, presenter) = makeSUT(rooms: rooms, adults: adults, childrenAge: childrenAge)

		sut.load(request: .init())

		XCTAssertEqual(presenter.messages, [
			.presentRoomGuests(.init(rooms: rooms, adults: adults, childrenAge: childrenAge))
		])
	}

	func test_didDecrementRooms_presentsUpdatedRooms() {
		let (sut, presenter) = makeSUT(rooms: 2)

		sut.didDecrementRooms()
		XCTAssertEqual(presenter.messages, [.presentUpdateRooms(.init(rooms: 1))])

		sut.didDecrementRooms()
		XCTAssertEqual(presenter.messages, [
			.presentUpdateRooms(.init(rooms: 1)),
			.presentUpdateRooms(.init(rooms: 1))
		])
	}

	func test_didIncrementRooms_presentsUpdatedRooms() {
		let (sut, presenter) = makeSUT(rooms: 29)

		sut.didIncrementRooms()
		XCTAssertEqual(presenter.messages, [.presentUpdateRooms(.init(rooms: 30))])

		sut.didIncrementRooms()
		XCTAssertEqual(presenter.messages, [
			.presentUpdateRooms(.init(rooms: 30)),
			.presentUpdateRooms(.init(rooms: 30))
		])
	}

	func test_didDecrementAdults_presentsUpdatedAdults() {
		let (sut, presenter) = makeSUT(adults: 2)
		
		sut.didDecrementAdults()
		XCTAssertEqual(presenter.messages, [.presentUpdateAdults(.init(adults: 1))])
		
		sut.didDecrementAdults()
		XCTAssertEqual(presenter.messages, [
			.presentUpdateAdults(.init(adults: 1)),
			.presentUpdateAdults(.init(adults: 1))
		])
	}

	func test_didIncrementAdults_presentsUpdatedAdults() {
		let (sut, presenter) = makeSUT(adults: 29)

		sut.didIncrementAdults()
		XCTAssertEqual(presenter.messages, [.presentUpdateAdults(.init(adults: 30))])

		sut.didIncrementAdults()
		XCTAssertEqual(presenter.messages, [
			.presentUpdateAdults(.init(adults: 30)),
			.presentUpdateAdults(.init(adults: 30))
		])
	}

	func test_didDecrementChildrenAge_presentsUpdatedChildrenAge() {
		let (sut, presenter) = makeSUT(childrenAge: [1, 2])

		sut.didDecrementChildrenAge()
		XCTAssertEqual(presenter.messages, [.presentUpdateChildrenAge(.init(childrenAge: [1]))])

		sut.didDecrementChildrenAge()
		XCTAssertEqual(presenter.messages, [
			.presentUpdateChildrenAge(.init(childrenAge: [1])),
			.presentUpdateChildrenAge(.init(childrenAge: []))
		])
	}

	func test_didIncrementChildrenAge_presentsUpdatedChildrenAge() {
		let (sut, presenter) = makeSUT(childrenAge: [])

		sut.didIncrementChildrenAge()
		XCTAssertEqual(presenter.messages, [.presentUpdateChildrenAge(.init(childrenAge: [nil]))])

		sut.didIncrementChildrenAge()
		XCTAssertEqual(presenter.messages, [
			.presentUpdateChildrenAge(.init(childrenAge: [nil])),
			.presentUpdateChildrenAge(.init(childrenAge: [nil, nil]))
		])
	}

	func test_didRequestAgePicker_presentsAgePicker() {
		let (sut, presenter) = makeSUT(childrenAge: [1, 2])

		sut.didRequestAgePicker(request: .init(index: 0))
		XCTAssertEqual(presenter.messages, [
			.presentAgePicker(.init(index: 0, availableAges: availableAges, selectedAge: 1))
		])

		sut.didRequestAgePicker(request: .init(index: 1))
		XCTAssertEqual(presenter.messages, [
			.presentAgePicker(.init(index: 0, availableAges: availableAges, selectedAge: 1)),
			.presentAgePicker(.init(index: 1, availableAges: availableAges, selectedAge: 2))
		])
	}

	func test_didSelectAge_presentsChildrenAge() {
		let (sut, presenter) = makeSUT(childrenAge: [1, 2])

		sut.didSelectAge(request: .init(index: 0, age: 3))
		XCTAssertEqual(presenter.messages, [
			.presentChildrenAge(.init(childrenAge: [3, 2]))
		])

		sut.didSelectAge(request: .init(index: 1, age: 5))
		XCTAssertEqual(presenter.messages, [
			.presentChildrenAge(.init(childrenAge: [3, 2])),
			.presentChildrenAge(.init(childrenAge: [3, 5]))
		])
	}

	func test_selectRoomGuests_presentsSelectedRoomGuests() {
		let rooms = 1
		let adults = 2
		let childrenAge = [3]
		let (sut, presenter) = makeSUT(rooms: rooms, adults: adults, childrenAge: childrenAge)

		sut.selectRoomGuests(request: .init())

		XCTAssertEqual(presenter.messages, [
			.presentSelectedRoomGuests(.init(rooms: rooms, adults: adults, childrenAge: childrenAge))
		])
	}

	// MARK: - Helpers

	private func makeSUT(
		rooms: Int = 1,
		adults: Int = 1,
		childrenAge: [Int] = []
	) -> (
		sut: RoomGuestsPickerInteractor,
		presenter: RoomGuestsPickerPresentationLogicSpy
	) {
		let presenter = RoomGuestsPickerPresentationLogicSpy()
		let sut = RoomGuestsPickerInteractor(
			rooms: rooms,
			adults: adults,
			childrenAge: childrenAge
		)
		sut.presenter = presenter
		return (sut, presenter)
	}
}

final class RoomGuestsPickerPresentationLogicSpy: RoomGuestsPickerPresentationLogic {
	enum Message: Equatable {
		case presentLimits(RoomGuestsPickerModels.LoadLimits.Response)
		case presentRoomGuests(RoomGuestsPickerModels.Load.Response)
		case presentUpdateRooms(RoomGuestsPickerModels.UpdateRooms.Response)
		case presentUpdateAdults(RoomGuestsPickerModels.UpdateAdults.Response)
		case presentUpdateChildrenAge(RoomGuestsPickerModels.UpdateChildrenAge.Response)
		case presentAgePicker(RoomGuestsPickerModels.AgeSelection.Response)
		case presentChildrenAge(RoomGuestsPickerModels.AgeSelected.Response)
		case presentSelectedRoomGuests(RoomGuestsPickerModels.Select.Response)
	}

	private(set) var messages = [Message]()

	func presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response) {
		messages.append(.presentLimits(response))
	}
	
	func presentRoomGuests(response: RoomGuestsPickerModels.Load.Response) {
		messages.append(.presentRoomGuests(response))
	}
	
	func presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response) {
		messages.append(.presentUpdateRooms(response))
	}
	
	func presentUpdateAdults(response: RoomGuestsPickerModels.UpdateAdults.Response) {
		messages.append(.presentUpdateAdults(response))
	}
	
	func presentUpdateChildrenAge(response: RoomGuestsPickerModels.UpdateChildrenAge.Response) {
		messages.append(.presentUpdateChildrenAge(response))
	}
	
	func presentAgePicker(response: RoomGuestsPickerModels.AgeSelection.Response) {
		messages.append(.presentAgePicker(response))
	}
	
	func presentChildrenAge(response: RoomGuestsPickerModels.AgeSelected.Response) {
		messages.append(.presentChildrenAge(response))
	}
	
	func presentSelectedRoomGuests(response: RoomGuestsPickerModels.Select.Response) {
		messages.append(.presentSelectedRoomGuests(response))
	}
}
