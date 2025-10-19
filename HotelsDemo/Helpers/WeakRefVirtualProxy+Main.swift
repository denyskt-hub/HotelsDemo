//
//  WeakRefVirtualProxy+Main.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/10/25.
//

import Foundation

// MARK: - MainScene

extension WeakRefVirtualProxy: MainScene where T: MainScene {}

// MARK: - MainDisplayLogic

extension WeakRefVirtualProxy: MainDisplayLogic where T: MainDisplayLogic {
	public func displaySearch(viewModel: MainModels.Search.ViewModel) {
		object?.displaySearch(viewModel: viewModel)
	}
}
