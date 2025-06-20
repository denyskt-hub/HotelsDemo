//
//  RoomGuestsPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

protocol RoomGuestsPickerBusinessLogic {
	func loadRoomGuestsLimits(request: RoomGuestsPickerModels.LoadLimits.Request)

	func didDecrementRooms()
	func didIncrementRooms()
}

final class RoomGuestsPickerInteractor: RoomGuestsPickerBusinessLogic {
	private var rooms: Int
	private var adults: Int
	private var childrenAge: [Int]

	var presenter: RoomGuestsPickerPresentationLogic?

	init(rooms: Int, adults: Int, childrenAge: [Int]) {
		self.rooms = rooms
		self.adults = adults
		self.childrenAge = childrenAge
	}

	func loadRoomGuestsLimits(request: RoomGuestsPickerModels.LoadLimits.Request) {
		let limits = RoomGuestsLimits(maxRooms: 30, maxAdults: 30, maxChildren: 10)
		presenter?.presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response(limits: limits))
	}

	func didDecrementRooms() {
		updateRooms(rooms - 1)
	}

	func didIncrementRooms() {
		updateRooms(rooms + 1)
	}

	private func updateRooms(_ rooms: Int) {
		self.rooms = rooms
		presenter?.presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response(rooms: rooms))
	}
}
