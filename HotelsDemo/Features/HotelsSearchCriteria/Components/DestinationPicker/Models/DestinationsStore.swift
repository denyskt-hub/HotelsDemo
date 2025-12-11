//
//  DestinationsStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 5/11/25.
//

import Foundation

actor DestinationsStore {
	private var destinations: [Destination] = []

	func update(_ newDestinations: [Destination]) {
		destinations = newDestinations
	}

	func get() -> [Destination] {
		destinations
	}

	func get(at index: Int) -> Destination? {
		guard destinations.indices.contains(index) else { return nil }

		return destinations[index]
	}
}
