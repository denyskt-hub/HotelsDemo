//
//  DestinationPickerComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/7/25.
//

import UIKit

@MainActor
public protocol DestinationPickerFactory {
	func makeDestinationPicker(delegate: DestinationPickerDelegate?) -> UIViewController
}

@MainActor
public final class DestinationPickerComposer: DestinationPickerFactory {
	private let client: HTTPClient
	private let baseURL: URL

	public init(
		client: HTTPClient,
		baseURL: URL
	) {
		self.client = client
		self.baseURL = baseURL
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
		DestinationSearchWorker(
			factory: DefaultDestinationRequestFactory(
				url: DestinationsEndpoint.searchDestination.url(baseURL)
			),
			client: client
		)
	}
}
