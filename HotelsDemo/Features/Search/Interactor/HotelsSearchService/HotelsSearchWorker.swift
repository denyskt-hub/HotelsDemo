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
			Hotel(name: "Hotel 1", position: 0),
			Hotel(name: "Hotel 2", position: 1),
			Hotel(name: "Hotel 3", position: 2),
		]))
	}
}
