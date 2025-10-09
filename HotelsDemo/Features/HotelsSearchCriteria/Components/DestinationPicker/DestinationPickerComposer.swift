//
//  DestinationPickerComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/7/25.
//

import UIKit

public protocol DestinationPickerFactory {
	func makeDestinationPicker(delegate: DestinationPickerDelegate?) -> UIViewController
}

public final class DestinationPickerComposer: DestinationPickerFactory {
	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	public func makeDestinationPicker(delegate: DestinationPickerDelegate?) -> UIViewController {
		let viewController = DestinationPickerViewController()
		let worker = DestinationSearchWorker(
			factory: DefaultDestinationRequestFactory(
				url: DestinationsEndpoint.searchDestination.url(Environment.baseURL)
			),
			client: client
		).dispatch(to: MainQueueDispatcher())
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
