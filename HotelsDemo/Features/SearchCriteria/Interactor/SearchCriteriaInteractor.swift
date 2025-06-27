//
//  SearchCriteriaInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public final class SearchCriteriaInteractor: SearchCriteriaBusinessLogic {
	private let provider: SearchCriteriaProvider
	private let cache: SearchCriteriaCache

	public var presenter: SearchCriteriaPresentationLogic?

	public init(
		provider: SearchCriteriaProvider,
		cache: SearchCriteriaCache
	) {
		self.provider = provider
		self.cache = cache
	}

	public func loadCriteria(request: SearchCriteriaModels.Load.Request) {
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

	public func loadDates(request: SearchCriteriaModels.LoadDates.Request) {
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

	public func loadRoomGuests(request: SearchCriteriaModels.LoadRoomGuests.Request) {
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

	public func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request) {
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

	public func updateDates(request: SearchCriteriaModels.UpdateDates.Request) {
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

	public func updateRoomGuests(request: SearchCriteriaModels.UpdateRoomGuests.Request) {
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

	private func load(_ completion: @escaping (Result<SearchCriteria, Error>) -> Void) {
		provider.retrieve(completion: completion)
	}

	private func save(_ criteria: SearchCriteria, _ completion: @escaping (Error?) -> Void) {
		cache.save(criteria, completion: completion)
	}

	private func update(
		_ transform: @escaping (inout SearchCriteria) -> Void,
		completion: @escaping ((Result<SearchCriteria, Error>) -> Void)
	) {
		load { result in
			switch result {
			case .success(var criteria):
				transform(&criteria)

				self.save(criteria) { error in
					if let error = error {
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
		completion: @escaping (Result<SearchCriteria, Error>) -> Void
	) {
		update({ $0.destination = destination }, completion: completion)
	}

	private func update(
		_ checkInDate: Date,
		_ checkOutDate: Date,
		completion: @escaping (Result<SearchCriteria, Error>) -> Void
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
		completion: @escaping (Result<SearchCriteria, Error>) -> Void
	) {
		update({
			$0.adults = adults
			$0.childrenAge = childrenAge
			$0.roomsQuantity = rooms
		}, completion: completion)
	}

	private func presentLoadedCriteria(_ criteria: SearchCriteria) {
		presenter?.presentLoadCriteria(response: SearchCriteriaModels.Load.Response(criteria: criteria))
	}

	private func presentLoadError(_ error: Error) {
		presenter?.presentLoadError(error)
	}

	private func presentLoadedRoomGuests(_ roomGuests: RoomGuests) {
		presenter?.presentRoomGuests(response: SearchCriteriaModels.LoadRoomGuests.Response(roomGuests: roomGuests))
	}

	private func presentLoadedDates(_ checkInDate: Date, _ checkOutDate: Date) {
		presenter?.presentDates(
			response: SearchCriteriaModels.LoadDates.Response(
				checkInDate: checkInDate,
				checkOutDate: checkOutDate
			)
		)
	}

	private func presentUpdatedDestinationCriteria(_ criteria: SearchCriteria) {
		presenter?.presentUpdateDestination(response: SearchCriteriaModels.UpdateDestination.Response(criteria: criteria))
	}

	private func presentUpdatedDatesCriteria(_ criteria: SearchCriteria) {
		presenter?.presentUpdateDates(response: SearchCriteriaModels.UpdateDates.Response(criteria: criteria))
	}

	private func presentUpdatedRoomGuestsCriteria(_ criteria: SearchCriteria) {
		presenter?.presentCriteria(response: SearchCriteriaModels.UpdateRoomGuests.Response(criteria: criteria))
	}

	private func presentUpdateError(_ error: Error) {
		presenter?.presentUpdateError(error)
	}
}
