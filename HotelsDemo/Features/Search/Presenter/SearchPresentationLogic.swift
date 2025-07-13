//
//  SearchPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol SearchPresentationLogic {
	func presentSearch(response: SearchModels.Search.Response)
	func presentSearchError(_ error: Error)
}
