//
//  AlwaysTrueHotelSpecification.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/8/25.
//

import Foundation

public struct AlwaysTrueHotelSpecification: HotelSpecification {
	public func isSatisfied(by hotel: Hotel) -> Bool { true }
}
