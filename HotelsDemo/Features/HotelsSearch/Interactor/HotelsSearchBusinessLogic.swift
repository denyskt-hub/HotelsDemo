//
//  HotelsSearchBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public protocol HotelsSearchBusinessLogic {
	func doFetchFilters(request: HotelsSearchModels.FetchFilters.Request)

	func handleViewDidAppear(request: HotelsSearchModels.ViewDidAppear.Request)
	func handleViewWillDisappearFromParent(request: HotelsSearchModels.ViewWillDisappearFromParent.Request)
	func handleFilterSelection(request: HotelsSearchModels.FilterSelection.Request)
}
