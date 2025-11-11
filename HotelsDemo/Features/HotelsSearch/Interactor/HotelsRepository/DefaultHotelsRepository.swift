//
//  DefaultHotelsRepository.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import Foundation
import Synchronization

public final class DefaultHotelsRepository: HotelsRepository {
	private let hotels: Mutex<[Hotel]>

	public init(hotels: [Hotel] = []) {
		self.hotels = Mutex(hotels)
	}

	public func allHotels() -> [Hotel] {
		hotels.withLock { $0 }
	}

	public func setHotels(_ hotels: [Hotel]) {
		self.hotels.withLock { $0 = hotels }
	}

	public func filter(with specification: any HotelSpecification) -> [Hotel] {
		hotels.withLock({ $0 }).filter { specification.isSatisfied(by: $0) }
	}
}
