//
//  SearchCriteria.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

struct SearchCriteria {
	var destination: Destination?
	let checkInDate: Date
	let checkOutDate: Date
	let adults: Int
	let childrenAge: String?
	let roomsQuantity: Int
}

extension SearchCriteria {
	static var `default`: SearchCriteria {
		SearchCriteria(
			destination: nil,
			checkInDate: .now.adding(days: 1),
			checkOutDate: .now.adding(days: 2),
			adults: 2,
			childrenAge: nil,
			roomsQuantity: 1
		)
	}
}
