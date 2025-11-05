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

@MainActor
public final class DestinationPickerComposer: DestinationPickerFactory {
	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	public func makeDestinationPicker(delegate: DestinationPickerDelegate?) -> UIViewController {
		let viewControllerProxy = WeakRefVirtualProxy<DestinationPickerViewController>()
		let worker = makeDestinationSearchService()

		let presenter = DestinationPickerPresenter(
			viewController: viewControllerProxy
		)

		let interactor = DestinationPickerInteractor(
			worker: worker,
			presenter: presenter
		)

		let viewController = DestinationPickerViewController(
			interactor: interactor,
			delegate: delegate
		)

		viewControllerProxy.object = viewController
		return viewController
	}

	private func makeDestinationSearchService() -> DestinationSearchService {
		let worker = DestinationSearchWorker(
			factory: DefaultDestinationRequestFactory(
				url: DestinationsEndpoint.searchDestination.url(Environment.baseURL)
			),
			client: client
		).dispatch(to: MainQueueDispatcher())

		return DebouncedDestinationSearchService(
			decoratee: worker,
			debouncer: DefaultDebouncer(delay: 0.5)
		)
	}
}
