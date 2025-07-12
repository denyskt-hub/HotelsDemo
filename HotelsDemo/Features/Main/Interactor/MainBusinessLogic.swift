//
//  MainBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol MainBusinessLogic {
	func search(request: MainModels.Search.Request)
}
