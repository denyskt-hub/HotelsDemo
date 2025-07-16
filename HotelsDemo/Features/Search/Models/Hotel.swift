//
//  Hotel.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public struct Hotel: Equatable {
	let id: Int
	let position: Int
	let name: String
	let starRating: Int
	let reviewCount: Int
	let reviewScore: Decimal
	let photoURLs: [URL]
	let price: Price
}

struct Price: Equatable {
	let grossPrice: Decimal
	let currency: String
}
