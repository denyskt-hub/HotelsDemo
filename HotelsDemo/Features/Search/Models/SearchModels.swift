//
//  SearchModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public enum SearchModels {
	public enum Search {
		public struct Request: Equatable {
			public let criteria: SearchCriteria

			public init(criteria: SearchCriteria) {
				self.criteria = criteria
			}
		}
	}
}
