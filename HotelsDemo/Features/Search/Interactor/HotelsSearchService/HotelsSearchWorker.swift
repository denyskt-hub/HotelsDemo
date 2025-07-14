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
				photoURLs: [URL(string: "https://cf.bstatic.com/xdata/images/hotel/square500/31204963.jpg?k=90c11832231c37a814e9631123bd28820e8ad8cd983b78ad529ea139791653d1&o=")!],
				price: .init(grossPrice: 324.23, currency: "USD")
			),
			Hotel(
				id: 2,
				position: 1,
				name: "Hotel 2",
				starRating: 4,
				reviewsCount: 33,
				reviewScore: 4.4,
				photoURLs: [URL(string: "https://cf.bstatic.com/xdata/images/hotel/square500/604298804.jpg?k=cce8e6992a6c78904e7a67b9611da9a34ed490aada9e82aa865b70f308200755&o=")!],
				price: .init(grossPrice: 50.0, currency: "USD")
			)
		]))
	}
}
