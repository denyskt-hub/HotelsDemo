//
//  MainInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class MainInteractor: MainBusinessLogic {
	public var presenter: MainPresentationLogic?

	public func handleSearch(request: MainModels.Search.Request) {
		presenter?.presentSearch(response: .init(criteria: request.criteria))
	}
}
