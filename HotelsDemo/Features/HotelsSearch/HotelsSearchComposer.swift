//
//  HotelsSearchComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

public protocol HotelsSearchFactory {
	func makeSearch(with criteria: SearchCriteria) -> UIViewController
}

public final class HotelsSearchComposer: HotelsSearchFactory {
	private let imageDataCache: ImageDataCache

	public init(imageDataCache: ImageDataCache) {
		self.imageDataCache = imageDataCache
	}

	public func makeSearch(with criteria: SearchCriteria) -> UIViewController {
		let viewController = HotelsSearchViewController()

		let mainQueueDispatcher = MainQueueDispatcher()
		let localImageDataLoader = LocalImageDataLoader(
			cache: imageDataCache,
			dispatcher: mainQueueDispatcher
		)
		let remoteImageDataLoader = RemoteImageDataLoader(
			client: URLSessionHTTPClient(),
			dispatcher: mainQueueDispatcher
		)
		let cachingImageDataLoader = CachingImageDataLoader(
			loader: remoteImageDataLoader,
			cache: imageDataCache
		)
		let viewControllerAdapter = HotelsSearchDisplayLogicAdapter(
			viewController: viewController,
			imageLoader: localImageDataLoader.fallback(to: cachingImageDataLoader)
		)
		let interactor = HotelsSearchInteractor(
			criteria: criteria,
			worker: HotelsSearchWorker(
				factory: DefaultHotelsRequestFactory(
					url: HotelsEndpoint.searchHotels.url(Environment.baseURL)
				),
				client: RapidAPIHTTPClient(client: URLSessionHTTPClient()),
				dispatcher: MainQueueDispatcher()
			)
		)
		let presenter = HotelsSearchPresenter()

		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewControllerAdapter

		return viewController
	}
}
