//
//  HotelsSearchWorker.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class HotelsSearchWorker: HotelsSearchService {
	public func search(criteria: SearchCriteria, completion: @escaping (HotelsSearchService.Result) -> Void) {
		completion(.success([
			Hotel(
				id: 1,
				position: 0,
				name: "Hotel 1",
				starRating: 5,
				reviewsCount: 203,
				reviewScore: 8.4,
				photoURLs: [],
				price: .init(grossPrice: 324.23, currency: "USD")
			),
			Hotel(
				id: 2,
				position: 1,
				name: "Hotel 2",
				starRating: 4,
				reviewsCount: 33,
				reviewScore: 4.4,
				photoURLs: [],
				price: .init(grossPrice: 50.0, currency: "USD")
			)
		]))
	}
}
