//
//  RoomGuests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public struct RoomGuests: Equatable, Sendable {
	public let rooms: Int
	public let adults: Int
	public let childrenAge: [Int]

	public init(
		rooms: Int,
		adults: Int,
		childrenAge: [Int]
	) {
		self.rooms = rooms
		self.adults = adults
		self.childrenAge = childrenAge
	}
}
