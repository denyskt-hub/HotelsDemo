//
//  RoomGuestsLimits.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public struct RoomGuestsLimits: Equatable {
	public let maxRooms: Int
	public let maxAdults: Int
	public let maxChildren: Int

	public init(
		maxRooms: Int,
		maxAdults: Int,
		maxChildren: Int
	) {
		self.maxRooms = maxRooms
		self.maxAdults = maxAdults
		self.maxChildren = maxChildren
	}
}
