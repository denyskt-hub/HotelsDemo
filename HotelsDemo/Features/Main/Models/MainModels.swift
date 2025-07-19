//
//  MainModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public enum MainModels {
	public enum Search {
		public struct Request: Equatable {
			public let criteria: HotelsSearchCriteria

			public init(criteria: HotelsSearchCriteria) {
				self.criteria = criteria
			}
		}

		public struct Response: Equatable {
			public let criteria: HotelsSearchCriteria

			public init(criteria: HotelsSearchCriteria) {
				self.criteria = criteria
			}
		}

		public struct ViewModel: Equatable {
			public let criteria: HotelsSearchCriteria

			public init(criteria: HotelsSearchCriteria) {
				self.criteria = criteria
			}
		}
	}
}
