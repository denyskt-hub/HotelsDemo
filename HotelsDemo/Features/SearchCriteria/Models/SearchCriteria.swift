//
//  SearchCriteria.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public struct SearchCriteria {
	var destination: Destination?
	var checkInDate: Date
	var checkOutDate: Date
	var adults: Int
	var childrenAge: [Int]
	var roomsQuantity: Int
}

extension SearchCriteria {
	static var `default`: SearchCriteria {
		let calendar = Calendar(identifier: .gregorian)
		let today = calendar.startOfDay(for: .now)

		return SearchCriteria(
			destination: nil,
			checkInDate: today.adding(days: 1),
			checkOutDate: today.adding(days: 2),
			adults: 2,
			childrenAge: [],
			roomsQuantity: 1
		)
	}
}
