//
//  HotelsFilterPicker.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

public protocol HotelsFilterPickerFactory {
	func makeFilter(delegate: HotelsFilterPickerDelegate?) -> UIViewController
}

public final class HotelsFilterPickerComposer: HotelsFilterPickerFactory {
	public func makeFilter(delegate: HotelsFilterPickerDelegate?) -> UIViewController {
		let viewController = HotelsFilterPickerViewController()
		let viewControllerAdapter = HotelsFilterPickerDisplayLogicAdapter(
			viewController: viewController
		)
		let interactor = HotelsFilterPickerInteractor(
			currentFilter: HotelsFilter()
		)
		let presenter = HotelsFilterPickerPresenter()

		viewController.interactor = interactor
		viewController.delegate = delegate
		interactor.presenter = presenter
		presenter.viewController = viewControllerAdapter

		return viewController
	}
}
