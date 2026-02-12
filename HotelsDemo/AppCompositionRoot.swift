//
//  AppCompositionRoot.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12.02.2026.
//

import UIKit

@MainActor
final class AppCompositionRoot {
	private lazy var environment: Environment.Config = {
		do {
			return try Environment.load()
		} catch {
			fatalError(
				"""
				Environment misconfigured: \(error)
				See README for required environment keys and configuration steps.
				"""
			)
		}
	}()

	private lazy var client: HTTPClient = {
		let base = URLSessionHTTPClient.shared
		let logging = LoggingHTTPClient(client: base)
		let rapid = RapidAPIHTTPClient(
			client: logging,
			apiHost: environment.apiHost,
			apiKey: environment.apiKey
		)
		return AppHTTPClient(decoratee: rapid)
	}()

	private lazy var calendar: Calendar = {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(secondsFromGMT: 0)!
		return calendar
	}()

	private lazy var storeURL: URL = {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		return documentsURL.appendingPathComponent("search-criteria.store")
	}()

	private lazy var searchCriteriaStore: HotelsSearchCriteriaStore = {
		ValidatingHotelsSearchCriteriaStore(
			decoratee: CodableHotelsSearchCriteriaStore(storeURL: storeURL),
			validator: DefaultHotelsSearchCriteriaValidator(
				calendar: calendar,
				currentDate: Date.init
			)
		)
	}()

	private lazy var defaultSearchCriteriaProvider: HotelsSearchCriteriaProvider = {
		DefaultHotelsSearchCriteriaProvider(
			calendar: calendar,
			currentDate: Date.init
		)
	}()

	private lazy var mainFactory: MainFactory = {
		MainComposer(
			client: client,
			baseURL: environment.baseURL,
			searchCriteriaFactory: makeSearchCriteriaViewController(delegate:)
		)
	}()

	private lazy var searchCriteriaFactory: HotelsSearchCriteriaFactory = {
		HotelsSearchCriteriaComposer(
			client: client,
			baseURL: environment.baseURL
		)
	}()

	func compose() -> UIViewController {
		makeMainViewController().embeddedInNavigationController()
	}

	private func makeMainViewController() -> UIViewController {
		mainFactory.makeMain()
	}

	private func makeSearchCriteriaViewController(delegate: HotelsSearchCriteriaDelegate) -> UIViewController {
		searchCriteriaFactory.makeSearchCriteria(
			delegate: delegate,
			provider: searchCriteriaStore.fallback(to: defaultSearchCriteriaProvider),
			cache: searchCriteriaStore,
			calendar: calendar
		)
	}
}
