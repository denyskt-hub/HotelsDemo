//
//  SearchCriteriaConstants.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 18/7/25.
//

import Foundation

public enum SearchLimits {
	static let minRooms = 1
	static let maxRooms = 30

	static let minAdults = 1
	static let maxAdults = 30

	static let minChildren = 0
	static let maxChildren = 10

	static let minChildAge = 0
	static let maxChildAge = 17

	static var availableChildAges: [Int] {
		Array(minChildAge...maxChildAge)
	}
}
