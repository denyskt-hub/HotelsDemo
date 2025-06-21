//
//  AgeFormatter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

struct AgeFormatter {
	static func string(for age: Int) -> String {
		switch age {
		case 0:
			return "< 1 year old"
		case 1:
			return "1 year old"
		default:
			return "\(age) years old"
		}
	}
}
