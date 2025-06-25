//
//  SearchCriteria.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public struct SearchCriteria: Equatable {
	public var destination: Destination?
	public var checkInDate: Date
	public var checkOutDate: Date
	public var adults: Int
	public var childrenAge: [Int]
	public var roomsQuantity: Int

	public init(
		destination: Destination? = nil,
		checkInDate: Date,
		checkOutDate: Date,
		adults: Int,
		childrenAge: [Int],
		roomsQuantity: Int
	) {
		self.destination = destination
		self.checkInDate = checkInDate
		self.checkOutDate = checkOutDate
		self.adults = adults
		self.childrenAge = childrenAge
		self.roomsQuantity = roomsQuantity
	}
}
