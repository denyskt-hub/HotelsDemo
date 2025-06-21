//
//  RoomGuestsPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

final class RoomGuestsPickerInteractor: RoomGuestsPickerBusinessLogic {
	private let limits = RoomGuestsLimits(maxRooms: 30, maxAdults: 30, maxChildren: 10)

	private var rooms: Int
	private var adults: Int
	private var childrenAge: [Int?]

	var presenter: RoomGuestsPickerPresentationLogic?

	init(rooms: Int, adults: Int, childrenAge: [Int]) {
		self.rooms = rooms
		self.adults = adults
		self.childrenAge = childrenAge
	}

	func loadLimits(request: RoomGuestsPickerModels.LoadLimits.Request) {
		presenter?.presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response(limits: limits))
	}

	func load(request: RoomGuestsPickerModels.Load.Request) {
		presenter?.presentRoomGuests(
			response: RoomGuestsPickerModels.Load.Response(
				rooms: rooms,
				adults: adults,
				childrenAge: childrenAge.compactMap { $0 }
			)
		)
	}

	func didDecrementRooms() {
		updateRooms(rooms - 1)
	}

	func didIncrementRooms() {
		updateRooms(rooms + 1)
	}

	func didDecrementAdults() {
		updateAdults(adults - 1)
	}

	func didIncrementAdults() {
		updateAdults(adults + 1)
	}

	func didDecrementChildrenAge() {
		guard !childrenAge.isEmpty else { return }

		childrenAge.removeLast()
		presenter?.presentUpdateChildrenAge(response: RoomGuestsPickerModels.UpdateChildrenAge.Response(childrenAge: childrenAge))
	}

	func didIncrementChildrenAge() {
		guard childrenAge.count < limits.maxChildren else { return }
		
		childrenAge.append(nil)
		presenter?.presentUpdateChildrenAge(response: RoomGuestsPickerModels.UpdateChildrenAge.Response(childrenAge: childrenAge))
	}

	func didRequestAgePicker(request: RoomGuestsPickerModels.AgeSelection.Request) {
		let index = request.index
		let availableAges = Array(1...17)
		let selectedAge = index < childrenAge.count ? childrenAge[index] : nil

		presenter?.presentAgePicker(
			response: RoomGuestsPickerModels.AgeSelection.Response(
				index: index,
				availableAges: availableAges,
				selectedAge: selectedAge
			)
		)
	}

	func didSelectAge(request: RoomGuestsPickerModels.AgeSelected.Request) {
		childrenAge[request.index] = request.age
		presenter?.presentChildrenAge(response: RoomGuestsPickerModels.AgeSelected.Response(childrenAge: childrenAge))
	}

	func selectRoomGuests(request: RoomGuestsPickerModels.Select.Request) {
		presenter?.presentSelectedRoomGuests(
			response: RoomGuestsPickerModels.Select.Response(
				rooms: rooms,
				adults: adults,
				childrenAge: childrenAge.compactMap { $0 }
			)
		)
	}

	private func updateRooms(_ rooms: Int) {
		self.rooms = min(max(rooms, 1), limits.maxRooms)
		presenter?.presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response(rooms: rooms))
	}

	private func updateAdults(_ adults: Int) {
		self.adults = min(max(adults, 1), limits.maxAdults)
		presenter?.presentUpdateAdults(response: RoomGuestsPickerModels.UpdateAdults.Response(adults: adults))
	}
}
