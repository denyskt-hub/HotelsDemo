//
//  HotelsSearchPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchPresentationLogic {
	func presentSearch(response: HotelsSearchModels.Search.Response)
	func presentSearchError(_ error: Error)
}
