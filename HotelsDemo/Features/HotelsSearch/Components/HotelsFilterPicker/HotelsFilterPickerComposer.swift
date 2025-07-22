//
//  HotelsFilterPicker.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

public protocol HotelsFilterPickerFactory {
	func makeFilter() -> UIViewController
}

public final class HotelsFilterPickerComposer: HotelsFilterPickerFactory {
	public func makeFilter() -> UIViewController {
		let viewController = HotelsFilterPickerViewController()
		let viewControllerAdapter = HotelsFilterPickerDisplayLogicAdapter(
			viewController: viewController
		)
		let interactor = HotelsFilterPickerInteractor(
			currentFilter: HotelsFilter()
		)
		let presenter = HotelsFilterPickerPresenter()

		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewControllerAdapter

		return viewController
	}
}
