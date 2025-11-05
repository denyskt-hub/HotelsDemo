//
//  Destination.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public struct Destination: Equatable, Sendable {
	public let id: Int
	public let type: String
	public let name: String
	public let label: String
	public let country: String
	public let cityName: String

	public init(
		id: Int,
		type: String,
		name: String,
		label: String,
		country: String,
		cityName: String
	) {
		self.id = id
		self.type = type
		self.name = name
		self.label = label
		self.country = country
		self.cityName = cityName
	}
}
