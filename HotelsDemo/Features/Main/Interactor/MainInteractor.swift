//
//  MainInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class MainInteractor: MainBusinessLogic {
	private let presenter: MainPresentationLogic

	public init(presenter: MainPresentationLogic) {
		self.presenter = presenter
	}

	public func handleSearch(request: MainModels.Search.Request) {
		presenter.presentSearch(response: .init(criteria: request.criteria))
	}
}
