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
		load { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				self.presentLoadedCriteria(criteria)
			case let .failure(error):
				self.presentLoadError(error)
			}
		}
	}

	public func doFetchDateRange(request: HotelsSearchCriteriaModels.FetchDates.Request) {
		load { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				self.presentLoadedDates(criteria.checkInDate, criteria.checkOutDate)
			case let .failure(error):
				self.presentLoadError(error)
			}
		}
	}

	public func doFetchRoomGuests(request: HotelsSearchCriteriaModels.FetchRoomGuests.Request) {
		load { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				let roomGuests = RoomGuests(
					rooms: criteria.roomsQuantity,
					adults: criteria.adults,
					childrenAge: criteria.childrenAge
				)
				self.presentLoadedRoomGuests(roomGuests)
			case let .failure(error):
				self.presentLoadError(error)
			}
		}
	}

	public func doSearch(request: HotelsSearchCriteriaModels.Search.Request) {
		load { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				self.presentSearch(criteria)
			case let .failure(error):
				self.presentLoadError(error)
			}
		}
	}

	public func handleDestinationSelection(request: HotelsSearchCriteriaModels.DestinationSelection.Request) {
		update(request.destination) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				self.presentUpdatedDestinationCriteria(criteria)
			case let .failure(error):
				self.presentUpdateError(error)
			}
		}
	}

	public func handleDateRangeSelection(request: HotelsSearchCriteriaModels.DateRangeSelection.Request) {
		update(request.checkInDate, request.checkOutDate) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				self.presentUpdatedDatesCriteria(criteria)
			case let .failure(error):
				self.presentUpdateError(error)
			}
		}
	}

	public func handleRoomGuestsSelection(request: HotelsSearchCriteriaModels.RoomGuestsSelection.Request) {
		update(request.rooms, request.adults, request.childrenAge) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				self.presentUpdatedRoomGuestsCriteria(criteria)
			case let .failure(error):
				self.presentUpdateError(error)
			}
		}
	}

	// MARK: -

	private func load(_ completion: @Sendable @escaping (Result<HotelsSearchCriteria, Error>) -> Void) {
		Task {
			do {
				let criteria = try await provider.retrieve()
				completion(.success(criteria))
			} catch {
				completion(.failure(error))
			}
		}
	}

	private func save(_ criteria: HotelsSearchCriteria, _ completion: @Sendable @escaping (Result<Void, Error>) -> Void) {
		cache.save(criteria, completion: completion)
	}

	private func update(
		_ transform: @Sendable @escaping (HotelsSearchCriteria) -> HotelsSearchCriteria,
		completion: @Sendable @escaping (Result<HotelsSearchCriteria, Error>) -> Void
	) {
		load { [weak self] result in
			guard let self else { return }

			switch result {
			case .success(let criteria):
				let newCriteria = transform(criteria)

				self.save(newCriteria) { saveResult in
					if case let .failure(error) = saveResult {
						completion(.failure(error))
					} else {
						completion(.success(newCriteria))
					}
				}
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}

	private func update(
		_ destination: Destination,
		completion: @Sendable @escaping (Result<HotelsSearchCriteria, Error>) -> Void
	) {
		update({ criteria in
			var newCriteria = criteria
			newCriteria.destination = destination
			return newCriteria
		}, completion: completion)
	}

	private func update(
		_ checkInDate: Date,
		_ checkOutDate: Date,
		completion: @Sendable @escaping (Result<HotelsSearchCriteria, Error>) -> Void
	) {
		update({ criteria in
			var newCriteria = criteria
			newCriteria.checkInDate = checkInDate
			newCriteria.checkOutDate = checkOutDate
			return newCriteria
		}, completion: completion)
	}

	private func update(
		_ rooms: Int,
		_ adults: Int,
		_ childrenAge: [Int],
		completion: @Sendable @escaping (Result<HotelsSearchCriteria, Error>) -> Void
	) {
		update({ criteria in
			var newCriteria = criteria
			newCriteria.adults = adults
			newCriteria.childrenAge = childrenAge
			newCriteria.roomsQuantity = rooms
			return newCriteria
		}, completion: completion)
	}

	// MARK: - 

	private func presentLoadedCriteria(_ criteria: HotelsSearchCriteria) {
		Task {
			await presenter.presentLoadCriteria(
				response: HotelsSearchCriteriaModels.FetchCriteria.Response(criteria: criteria)
			)
		}
	}

	private func presentLoadError(_ error: Error) {
		Task { await presenter.presentLoadError(error) }
	}

	private func presentLoadedRoomGuests(_ roomGuests: RoomGuests) {
		Task {
			await presenter.presentRoomGuests(
				response: HotelsSearchCriteriaModels.FetchRoomGuests.Response(roomGuests: roomGuests)
			)
		}
	}

	private func presentLoadedDates(_ checkInDate: Date, _ checkOutDate: Date) {
		Task {
			await presenter.presentDates(
				response: HotelsSearchCriteriaModels.FetchDates.Response(
					checkInDate: checkInDate,
					checkOutDate: checkOutDate
				)
			)
		}
	}

	private func presentUpdatedDestinationCriteria(_ criteria: HotelsSearchCriteria) {
		Task {
			await presenter.presentUpdateDestination(
				response: HotelsSearchCriteriaModels.DestinationSelection.Response(criteria: criteria)
			)
		}
	}

	private func presentUpdatedDatesCriteria(_ criteria: HotelsSearchCriteria) {
		Task {
			await presenter.presentUpdateDates(
				response: HotelsSearchCriteriaModels.DateRangeSelection.Response(criteria: criteria)
			)
		}
	}

	private func presentUpdatedRoomGuestsCriteria(_ criteria: HotelsSearchCriteria) {
		Task {
			await presenter.presentUpdateRoomGuests(
				response: HotelsSearchCriteriaModels.RoomGuestsSelection.Response(criteria: criteria)
			)
		}
	}

	private func presentUpdateError(_ error: Error) {
		Task { await presenter.presentUpdateError(error) }
	}

	private func presentSearch(_ criteria: HotelsSearchCriteria) {
		Task {
			await presenter.presentSearch(
				response: HotelsSearchCriteriaModels.Search.Response(criteria: criteria)
			)
		}
	}
}
