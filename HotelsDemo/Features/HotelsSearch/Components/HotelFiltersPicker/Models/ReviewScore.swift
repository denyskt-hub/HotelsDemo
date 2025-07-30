//
//  ReviewScore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public enum ReviewScore: Decimal, CaseIterable {
	case fair = 5.0
	case pleasant = 6.0
	case good = 7.0
	case veryGood = 8.0
	case wonderful = 9.0
}

public extension ReviewScore {
	var title: String {
		switch self {
		case .fair:
			return "Fair"
		case .pleasant:
			return "Pleasant"
		case .good:
			return "Good"
		case .veryGood:
			return "Very good"
		case .wonderful:
			return "Wonderful"
		}
	}
}
