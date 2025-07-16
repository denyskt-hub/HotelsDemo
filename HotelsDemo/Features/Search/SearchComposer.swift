//
//  SearchComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

public protocol SearchFactory {
	func makeSearch(with criteria: SearchCriteria) -> UIViewController
}

public final class SearchComposer: SearchFactory {
	private let imageDataCache: ImageDataCache

	public init(imageDataCache: ImageDataCache) {
		self.imageDataCache = imageDataCache
	}

	public func makeSearch(with criteria: SearchCriteria) -> UIViewController {
		let viewController = SearchViewController()

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
		let viewControllerAdapter = SearchDisplayLogicAdapter(
			viewController: viewController,
			imageLoader: localImageDataLoader.fallback(to: cachingImageDataLoader)
		)
		let interactor = SearchInteractor(
			criteria: criteria,
			worker: HotelsSearchWorker(
				client: RapidAPIHTTPClient(client: URLSessionHTTPClient()),
				dispatcher: MainQueueDispatcher()
			)
		)
		let presenter = SearchPresenter()

		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewControllerAdapter

		return viewController
	}
}
