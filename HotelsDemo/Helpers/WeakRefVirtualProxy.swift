//
//  WeakRefVirtualProxy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
	weak var object: T?

	init(object: T? = nil) {
		self.object = object
	}
}

extension WeakRefVirtualProxy: SearchCriteriaDelegate where T: SearchCriteriaDelegate {
	func didRequestSearch(with searchCriteria: SearchCriteria) {
		object?.didRequestSearch(with: searchCriteria)
	}
}
