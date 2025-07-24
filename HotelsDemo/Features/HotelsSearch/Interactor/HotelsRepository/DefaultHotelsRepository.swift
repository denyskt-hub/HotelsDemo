//
//  DefaultHotelsRepository.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import Foundation

public final class DefaultHotelsRepository: HotelsRepository {
	private var hotels: [Hotel]

	public init(hotels: [Hotel] = []) {
		self.hotels = hotels
	}

	public func allHotels() -> [Hotel] {
		hotels
	}

	public func setHotels(_ hotels: [Hotel]) {
		self.hotels = hotels
	}

	public func filter(with specification: any HotelSpecification) -> [Hotel] {
		hotels.filter { specification.isSatisfied(by: $0) }
	}
}
