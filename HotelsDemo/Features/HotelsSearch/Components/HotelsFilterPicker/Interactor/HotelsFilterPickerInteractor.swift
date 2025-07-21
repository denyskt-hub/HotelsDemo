//
//  HotelsFilterPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public final class HotelsFilterPickerInteractor: HotelsFilterPickerBusinessLogic {
	private var currentFilter: HotelsFilter

	public var presenter: HotelsFilterPickerPresentationLogic?

	public init(currentFilter: HotelsFilter) {
		self.currentFilter = currentFilter
	}

	public func load(request: HotelsFilterPickerModels.Load.Request) {
		presenter?.presentLoad(response: .init(filter: currentFilter))
	}
}
