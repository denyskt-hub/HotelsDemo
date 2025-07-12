//
//  RoomGuestsPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public final class RoomGuestsPickerInteractor: RoomGuestsPickerBusinessLogic {
	private let limits = RoomGuestsLimits(maxRooms: 30, maxAdults: 30, maxChildren: 10)
	private let availableAges = Array(0...17)

	private var rooms: Int
	private var adults: Int
	private var childrenAge: [Int?]

	public var presenter: RoomGuestsPickerPresentationLogic?

	public init(
		rooms: Int,
		adults: Int,
		childrenAge: [Int]
	) {
		self.rooms = rooms
		self.adults = adults
		self.childrenAge = childrenAge
	}

	public func loadLimits(request: RoomGuestsPickerModels.LoadLimits.Request) {
		presenter?.presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response(limits: limits))
	}

	public func load(request: RoomGuestsPickerModels.Load.Request) {
		presenter?.presentRoomGuests(
			response: RoomGuestsPickerModels.Load.Response(
				rooms: rooms,
				adults: adults,
				childrenAge: childrenAge.compactMap { $0 }
			)
		)
	}

	public func didDecrementRooms() {
		updateRooms(rooms - 1)
	}

	public func didIncrementRooms() {
		updateRooms(rooms + 1)
	}

	public func didDecrementAdults() {
		updateAdults(adults - 1)
	}

	public func didIncrementAdults() {
		updateAdults(adults + 1)
	}

	public func didDecrementChildrenAge() {
		guard !childrenAge.isEmpty else { return }

		childrenAge.removeLast()
		presenter?.presentUpdateChildrenAge(
			response: RoomGuestsPickerModels.UpdateChildrenAge.Response(
				childrenAge: childrenAge
			)
		)
	}

	public func didIncrementChildrenAge() {
		guard childrenAge.count < limits.maxChildren else { return }
		
		childrenAge.append(nil)
		presenter?.presentUpdateChildrenAge(
			response: RoomGuestsPickerModels.UpdateChildrenAge.Response(
				childrenAge: childrenAge
			)
		)
	}

	public func didRequestAgePicker(request: RoomGuestsPickerModels.AgeSelection.Request) {
		let index = request.index
		guard childrenAge.indices.contains(index) else {
			preconditionFailure("Invalid index from UI: \(index), childrenAge count: \(childrenAge.count)")
		}

		let selectedAge = childrenAge[index]

		presenter?.presentAgePicker(
			response: RoomGuestsPickerModels.AgeSelection.Response(
				index: index,
				availableAges: availableAges,
				selectedAge: selectedAge
			)
		)
	}

	public func didSelectAge(request: RoomGuestsPickerModels.AgeSelected.Request) {
		let index = request.index
		guard childrenAge.indices.contains(index) else {
			preconditionFailure("Invalid index from UI: \(index), childrenAge count: \(childrenAge.count)")
		}
		guard availableAges.contains(request.age) else {
			preconditionFailure("Invalid age selected: \(request.age). Available: \(availableAges)")
		}
		
		childrenAge[index] = request.age
		presenter?.presentChildrenAge(
			response: RoomGuestsPickerModels.AgeSelected.Response(
				childrenAge: childrenAge
			)
		)
	}

	public func selectRoomGuests(request: RoomGuestsPickerModels.Select.Request) {
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
		presenter?.presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response(rooms: self.rooms))
	}

	private func updateAdults(_ adults: Int) {
		self.adults = min(max(adults, 1), limits.maxAdults)
		presenter?.presentUpdateAdults(response: RoomGuestsPickerModels.UpdateAdults.Response(adults: self.adults))
	}
}
