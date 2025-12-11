//
//  HotelsSearchCriteriaInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public final class HotelsSearchCriteriaInteractor: HotelsSearchCriteriaBusinessLogic {
	private let cache: HotelsSearchCriteriaCache
	private let provider: HotelsSearchCriteriaProvider
	private let presenter: HotelsSearchCriteriaPresentationLogic

	public init(
		cache: HotelsSearchCriteriaCache,
		provider: HotelsSearchCriteriaProvider,
		presenter: HotelsSearchCriteriaPresentationLogic
	) {
		self.cache = cache
		self.provider = provider
		self.presenter = presenter
	}

	public func doFetchCriteria(request: HotelsSearchCriteriaModels.FetchCriteria.Request) {
		Task { [weak self] in
			guard let self else { return }

			do {
				let criteria = try await self.load()
				await self.presentLoadedCriteria(criteria)
			} catch {
				await self.presentLoadError(error)
			}
		}
	}

	public func doFetchDateRange(request: HotelsSearchCriteriaModels.FetchDates.Request) {
		Task { [weak self] in
			guard let self else { return }

			do {
				let criteria = try await self.load()
				await self.presentLoadedDates(criteria.checkInDate, criteria.checkOutDate)
			} catch {
				await self.presentLoadError(error)
			}
		}
	}

	public func doFetchRoomGuests(request: HotelsSearchCriteriaModels.FetchRoomGuests.Request) {
		Task { [weak self] in
			guard let self else { return }

			do {
				let criteria = try await self.load()
				let roomGuests = RoomGuests(
					rooms: criteria.roomsQuantity,
					adults: criteria.adults,
					childrenAge: criteria.childrenAge
				)
				await self.presentLoadedRoomGuests(roomGuests)
			} catch {
				await self.presentLoadError(error)
			}
		}
	}

	public func doSearch(request: HotelsSearchCriteriaModels.Search.Request) {
		Task { [weak self] in
			guard let self else { return }

			do {
				let criteria = try await self.load()
				await self.presentSearch(criteria)
			} catch {
				await self.presentLoadError(error)
			}
		}
	}

	public func handleDestinationSelection(request: HotelsSearchCriteriaModels.DestinationSelection.Request) {
		Task { [weak self] in
			guard let self else { return }

			do {
				let criteria = try await self.update(request.destination)
				await self.presentUpdatedDestinationCriteria(criteria)
			} catch {
				await self.presentUpdateError(error)
			}
		}
	}

	public func handleDateRangeSelection(request: HotelsSearchCriteriaModels.DateRangeSelection.Request) {
		Task { [weak self] in
			guard let self else { return }

			do {
				let criteria = try await self.update(request.checkInDate, request.checkOutDate)
				await self.presentUpdatedDatesCriteria(criteria)
			} catch {
				await self.presentUpdateError(error)
			}
		}
	}

	public func handleRoomGuestsSelection(request: HotelsSearchCriteriaModels.RoomGuestsSelection.Request) {
		Task { [weak self] in
			guard let self else { return }

			do {
				let criteria = try await self.update(request.rooms, request.adults, request.childrenAge)
				await self.presentUpdatedRoomGuestsCriteria(criteria)
			} catch {
				await self.presentUpdateError(error)
			}
		}
	}

	// MARK: -

	private func load() async throws -> HotelsSearchCriteria {
		try await provider.retrieve()
	}

	private func save(_ criteria: HotelsSearchCriteria) async throws {
		try await cache.save(criteria)
	}

	private func update(
		_ transform: @Sendable @escaping (HotelsSearchCriteria) -> HotelsSearchCriteria
	) async throws -> HotelsSearchCriteria {
		let criteria = try await load()
		let newCriteria = transform(criteria)
		try await save(newCriteria)
		return newCriteria
	}

	private func update(
		_ destination: Destination
	) async throws -> HotelsSearchCriteria {
		try await update { criteria in
			var newCriteria = criteria
			newCriteria.destination = destination
			return newCriteria
		}
	}

	private func update(
		_ checkInDate: Date,
		_ checkOutDate: Date
	) async throws -> HotelsSearchCriteria {
		try await update { criteria in
			var newCriteria = criteria
			newCriteria.checkInDate = checkInDate
			newCriteria.checkOutDate = checkOutDate
			return newCriteria
		}
	}

	private func update(
		_ rooms: Int,
		_ adults: Int,
		_ childrenAge: [Int]
	) async throws -> HotelsSearchCriteria {
		try await update { criteria in
			var newCriteria = criteria
			newCriteria.adults = adults
			newCriteria.childrenAge = childrenAge
			newCriteria.roomsQuantity = rooms
			return newCriteria
		}
	}

	// MARK: - 

	private func presentLoadedCriteria(_ criteria: HotelsSearchCriteria) async {
		await presenter.presentLoadCriteria(
			response: HotelsSearchCriteriaModels.FetchCriteria.Response(criteria: criteria)
		)
	}

	private func presentLoadError(_ error: Error) async {
		await presenter.presentLoadError(error)
	}

	private func presentLoadedRoomGuests(_ roomGuests: RoomGuests) async {
		await presenter.presentRoomGuests(
			response: HotelsSearchCriteriaModels.FetchRoomGuests.Response(roomGuests: roomGuests)
		)
	}

	private func presentLoadedDates(_ checkInDate: Date, _ checkOutDate: Date) async {
		await presenter.presentDates(
			response: HotelsSearchCriteriaModels.FetchDates.Response(
				checkInDate: checkInDate,
				checkOutDate: checkOutDate
			)
		)
	}

	private func presentUpdatedDestinationCriteria(_ criteria: HotelsSearchCriteria) async {
		await presenter.presentUpdateDestination(
			response: HotelsSearchCriteriaModels.DestinationSelection.Response(criteria: criteria)
		)
	}

	private func presentUpdatedDatesCriteria(_ criteria: HotelsSearchCriteria) async {
		await presenter.presentUpdateDates(
			response: HotelsSearchCriteriaModels.DateRangeSelection.Response(criteria: criteria)
		)
	}

	private func presentUpdatedRoomGuestsCriteria(_ criteria: HotelsSearchCriteria) async {
		await presenter.presentUpdateRoomGuests(
			response: HotelsSearchCriteriaModels.RoomGuestsSelection.Response(criteria: criteria)
		)
	}

	private func presentUpdateError(_ error: Error) async {
		await presenter.presentUpdateError(error)
	}

	private func presentSearch(_ criteria: HotelsSearchCriteria) async {
		await presenter.presentSearch(
			response: HotelsSearchCriteriaModels.Search.Response(criteria: criteria)
		)
	}
}
