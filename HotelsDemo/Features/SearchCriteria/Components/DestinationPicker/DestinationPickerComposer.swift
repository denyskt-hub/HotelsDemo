//
//  DestinationPickerComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/7/25.
//

import UIKit
import Foundation

public protocol DestinationPickerFactory {
	func makeDestinationPicker(delegate: DestinationPickerDelegate?) -> UIViewController
}

public final class DestinationPickerComposer: DestinationPickerFactory {
	public func makeDestinationPicker(delegate: DestinationPickerDelegate?) -> UIViewController {
		let viewController = DestinationPickerViewController()
		let worker = DestinationSearchWorker(
			factory: DefaultDestinationRequestFactory(
				url: DestinationsEndpoint.searchDestination.url(Environment.baseURL)
			),
			client: RapidAPIHTTPClient(client: URLSessionHTTPClient()),
			dispatcher: MainQueueDispatcher()
		)
		let interactor = DestinationPickerInteractor(
			worker: worker,
			debouncer: DefaultDebouncer(delay: 0.5)
		)
		let presenter = DestinationPickerPresenter()

		viewController.interactor = interactor
		viewController.delegate = delegate
		interactor.presenter = presenter
		presenter.viewController = viewController

		return viewController
	}
}
