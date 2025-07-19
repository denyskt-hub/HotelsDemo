//
//  RoomGuestsPickerDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol RoomGuestsPickerDelegate: AnyObject {
	func didSelectRoomGuests(rooms: Int, adults: Int, childrenAges: [Int])
}
