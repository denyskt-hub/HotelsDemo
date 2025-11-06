//
//  HotelsRepository.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import Foundation

public protocol HotelsRepository: Sendable {
	func allHotels() -> [Hotel]
	func setHotels(_ hotels: [Hotel])
	func filter(with specification: any HotelSpecification) -> [Hotel]
}
