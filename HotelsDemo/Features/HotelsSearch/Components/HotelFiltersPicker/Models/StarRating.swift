//
//  StarRating.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public enum StarRating: Int, CaseIterable {
	case one = 1
	case two = 2
	case three = 3
	case four = 4
	case five = 5
}

public extension StarRating {
	var title: String {
		switch self {
		case .one:
			return "1 star"
		case .two:
			return "2 stars"
		case .three:
			return "3 stars"
		case .four:
			return "4 stars"
		case .five:
			return "5 stars"
		}
	}
}
