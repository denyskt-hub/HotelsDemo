//
//  RoomGuestsPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public final class RoomGuestsPickerInteractor: RoomGuestsPickerBusinessLogic {
	private let presenter: RoomGuestsPickerPresentationLogic

	private let limits = RoomGuestsLimits(
		maxRooms: HotelsSearchLimits.maxRooms,
		maxAdults: HotelsSearchLimits.maxRooms,
		maxChildren: HotelsSearchLimits.maxChildren
	)
	private let availableChildAges = HotelsSearchLimits.availableChildAges

	private var rooms: Int
	private var adults: Int
	private var childrenAge: [Int?]

	public init(
		rooms: Int,
		adults: Int,
		childrenAge: [Int],
		presenter: RoomGuestsPickerPresentationLogic
	) {
		self.rooms = rooms
		self.adults = adults
		self.childrenAge = childrenAge
		self.presenter = presenter
	}

	public func doFetchLimits(request: RoomGuestsPickerModels.FetchLimits.Request) {
		presenter.presentLimits(response: RoomGuestsPickerModels.FetchLimits.Response(limits: limits))
	}

	public func doFetchRoomGuests(request: RoomGuestsPickerModels.FetchRoomGuests.Request) {
		presenter.presentRoomGuests(
			response: RoomGuestsPickerModels.FetchRoomGuests.Response(
				rooms: rooms,
				adults: adults,
				childrenAge: childrenAge.compactMap { $0 }
			)
		)
	}

	public func handleDecrementRooms() {
		updateRooms(rooms - 1)
	}

	public func handleIncrementRooms() {
		updateRooms(rooms + 1)
	}

	public func handleDecrementAdults() {
		updateAdults(adults - 1)
	}

	public func handleIncrementAdults() {
		updateAdults(adults + 1)
	}

	public func handleDecrementChildrenAge() {
		guard !childrenAge.isEmpty else { return }

		childrenAge.removeLast()
		presenter.presentUpdateChildrenAge(
			response: RoomGuestsPickerModels.UpdateChildrenAge.Response(
				childrenAge: childrenAge
			)
		)
	}

	public func handleIncrementChildrenAge() {
		guard childrenAge.count < limits.maxChildren else { return }

		childrenAge.append(nil)
		presenter.presentUpdateChildrenAge(
			response: RoomGuestsPickerModels.UpdateChildrenAge.Response(
				childrenAge: childrenAge
			)
		)
	}

	public func handleAgePicker(request: RoomGuestsPickerModels.AgeSelection.Request) {
		let index = request.index
		guard childrenAge.indices.contains(index) else {
			preconditionFailure("Invalid index from UI: \(index), childrenAge count: \(childrenAge.count)")
		}

		let selectedAge = childrenAge[index]

		presenter.presentAgePicker(
			response: RoomGuestsPickerModels.AgeSelection.Response(
				index: index,
				availableAges: availableChildAges,
				selectedAge: selectedAge
			)
		)
	}

	public func handleAgeSelection(request: RoomGuestsPickerModels.AgeSelected.Request) {
		let index = request.index
		guard childrenAge.indices.contains(index) else {
			preconditionFailure("Invalid index from UI: \(index), childrenAge count: \(childrenAge.count)")
		}
		guard availableChildAges.contains(request.age) else {
			preconditionFailure("Invalid age selected: \(request.age). Available: \(availableChildAges)")
		}

		childrenAge[index] = request.age
		presenter.presentChildrenAge(
			response: RoomGuestsPickerModels.AgeSelected.Response(
				childrenAge: childrenAge
			)
		)
	}

	public func handleRoomGuestsSelection(request: RoomGuestsPickerModels.Select.Request) {
		presenter.presentSelectedRoomGuests(
			response: RoomGuestsPickerModels.Select.Response(
				rooms: rooms,
				adults: adults,
				childrenAge: childrenAge.compactMap { $0 }
			)
		)
	}

	private func updateRooms(_ rooms: Int) {
		self.rooms = min(max(rooms, 1), limits.maxRooms)
		presenter.presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response(rooms: self.rooms))
	}

	private func updateAdults(_ adults: Int) {
		self.adults = min(max(adults, 1), limits.maxAdults)
		presenter.presentUpdateAdults(response: RoomGuestsPickerModels.UpdateAdults.Response(adults: self.adults))
	}
}
