//
//  MainRoutingLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

@MainActor
public protocol MainRoutingLogic {
	func routeToSearch(viewModel: MainModels.Search.ViewModel)
}
