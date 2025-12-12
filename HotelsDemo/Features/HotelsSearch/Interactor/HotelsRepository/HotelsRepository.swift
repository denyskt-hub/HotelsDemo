//
//  HotelsRepository.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import Foundation

public protocol HotelsRepository: Sendable {
	func allHotels() async -> [Hotel]
	func setHotels(_ hotels: [Hotel]) async
	func filter(with specification: any HotelSpecification) async -> [Hotel]
}
