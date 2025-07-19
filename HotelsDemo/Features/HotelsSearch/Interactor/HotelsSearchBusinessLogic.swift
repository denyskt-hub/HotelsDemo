//
//  SearchBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchBusinessLogic {
	func search(request: HotelsSearchModels.Search.Request)
}
