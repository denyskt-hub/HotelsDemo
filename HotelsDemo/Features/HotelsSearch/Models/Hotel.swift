//
//  Hotel.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public struct Hotel: Equatable {
	public let id: Int
	public let position: Int
	public let name: String
	public let starRating: Int
	public let reviewCount: Int
	public let reviewScore: Decimal
	public let photoURLs: [URL]
	public let price: Price

	public init(
		id: Int,
		position: Int,
		name: String,
		starRating: Int,
		reviewCount: Int,
		reviewScore: Decimal,
		photoURLs: [URL],
		price: Price
	) {
		self.id = id
		self.position = position
		self.name = name
		self.starRating = starRating
		self.reviewCount = reviewCount
		self.reviewScore = reviewScore
		self.photoURLs = photoURLs
		self.price = price
	}
}

public struct Price: Equatable {
	public let grossPrice: Decimal
	public let currency: String

	public init(
		grossPrice: Decimal,
		currency: String
	) {
		self.grossPrice = grossPrice
		self.currency = currency
	}
}
