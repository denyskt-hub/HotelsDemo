//
//  HotelsSearchCriteriaInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public final class HotelsSearchCriteriaInteractor: HotelsSearchCriteriaBusinessLogic {
	private let provider: HotelsSearchCriteriaProvider
	private let cache: HotelsSearchCriteriaCache

	public var presenter: HotelsSearchCriteriaPresentationLogic?

	public init(
		provider: HotelsSearchCriteriaProvider,
		cache: HotelsSearchCriteriaCache
	) {
		self.provider = provider
		self.cache = cache
	}

	public func loadCriteria(request: HotelsSearchCriteriaModels.Load.Request) {
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

	public func loadDates(request: HotelsSearchCriteriaModels.LoadDates.Request) {
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

	public func loadRoomGuests(request: HotelsSearchCriteriaModels.LoadRoomGuests.Request) {
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

	public func updateDestination(request: HotelsSearchCriteriaModels.UpdateDestination.Request) {
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

	public func updateDates(request: HotelsSearchCriteriaModels.UpdateDates.Request) {
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

	public func updateRoomGuests(request: HotelsSearchCriteriaModels.UpdateRoomGuests.Request) {
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

	public func search(request: HotelsSearchCriteriaModels.Search.Request) {
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

	private func load(_ completion: @escaping (Result<HotelsSearchCriteria, Error>) -> Void) {
		provider.retrieve(completion: completion)
	}

	private func save(_ criteria: HotelsSearchCriteria, _ completion: @escaping (Result<Void, Error>) -> Void) {
		cache.save(criteria, completion: completion)
	}

	private func update(
		_ transform: @escaping (inout HotelsSearchCriteria) -> Void,
		completion: @escaping ((Result<HotelsSearchCriteria, Error>) -> Void)
	) {
		load { [weak self] result in
			guard let self else { return }
			
			switch result {
			case .success(var criteria):
				transform(&criteria)

				self.save(criteria) { saveResult in
					if case let .failure(error) = saveResult {
						completion(.failure(error))
					} else {
						completion(.success(criteria))
					}
				}
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}

	private func update(
		_ destination: Destination,
		completion: @escaping (Result<HotelsSearchCriteria, Error>) -> Void
	) {
		update({ $0.destination = destination }, completion: completion)
	}

	private func update(
		_ checkInDate: Date,
		_ checkOutDate: Date,
		completion: @escaping (Result<HotelsSearchCriteria, Error>) -> Void
	) {
		update({
			$0.checkInDate = checkInDate
			$0.checkOutDate = checkOutDate
		}, completion: completion)
	}

	private func update(
		_ rooms: Int,
		_ adults: Int,
		_ childrenAge: [Int],
		completion: @escaping (Result<HotelsSearchCriteria, Error>) -> Void
	) {
		update({
			$0.adults = adults
			$0.childrenAge = childrenAge
			$0.roomsQuantity = rooms
		}, completion: completion)
	}

	private func presentLoadedCriteria(_ criteria: HotelsSearchCriteria) {
		presenter?.presentLoadCriteria(
			response: HotelsSearchCriteriaModels.Load.Response(criteria: criteria)
		)
	}

	private func presentLoadError(_ error: Error) {
		presenter?.presentLoadError(error)
	}

	private func presentLoadedRoomGuests(_ roomGuests: RoomGuests) {
		presenter?.presentRoomGuests(
			response: HotelsSearchCriteriaModels.LoadRoomGuests.Response(roomGuests: roomGuests)
		)
	}

	private func presentLoadedDates(_ checkInDate: Date, _ checkOutDate: Date) {
		presenter?.presentDates(
			response: HotelsSearchCriteriaModels.LoadDates.Response(
				checkInDate: checkInDate,
				checkOutDate: checkOutDate
			)
		)
	}

	private func presentUpdatedDestinationCriteria(_ criteria: HotelsSearchCriteria) {
		presenter?.presentUpdateDestination(
			response: HotelsSearchCriteriaModels.UpdateDestination.Response(criteria: criteria)
		)
	}

	private func presentUpdatedDatesCriteria(_ criteria: HotelsSearchCriteria) {
		presenter?.presentUpdateDates(
			response: HotelsSearchCriteriaModels.UpdateDates.Response(criteria: criteria)
		)
	}

	private func presentUpdatedRoomGuestsCriteria(_ criteria: HotelsSearchCriteria) {
		presenter?.presentUpdateRoomGuests(
			response: HotelsSearchCriteriaModels.UpdateRoomGuests.Response(criteria: criteria)
		)
	}

	private func presentUpdateError(_ error: Error) {
		presenter?.presentUpdateError(error)
	}

	private func presentSearch(_ criteria: HotelsSearchCriteria) {
		presenter?.presentSearch(response: HotelsSearchCriteriaModels.Search.Response(criteria: criteria))
	}
}
