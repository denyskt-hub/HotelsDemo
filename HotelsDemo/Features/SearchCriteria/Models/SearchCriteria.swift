//
//  SearchCriteria.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public struct SearchCriteria: Equatable {
	var destination: Destination?
	var checkInDate: Date
	var checkOutDate: Date
	var adults: Int
	var childrenAge: [Int]
	var roomsQuantity: Int
}
