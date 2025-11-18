//
//  CodableHotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public final class CodableHotelsSearchCriteriaStore: HotelsSearchCriteriaStore {
	private struct CodableSearchCriteria: Codable {
		var destination: CodableDestination?
		let checkInDate: Date
		let checkOutDate: Date
		let adults: Int
		let childrenAge: [Int]
		let roomsQuantity: Int

		var model: HotelsSearchCriteria {
			HotelsSearchCriteria(
				destination: destination?.model,
				checkInDate: checkInDate,
				checkOutDate: checkOutDate,
				adults: adults,
				childrenAge: childrenAge,
				roomsQuantity: roomsQuantity
			)
		}

		init(model: HotelsSearchCriteria) {
			self.destination = model.destination.map(CodableDestination.init)
			self.checkInDate = model.checkInDate
			self.checkOutDate = model.checkOutDate
			self.adults = model.adults
			self.childrenAge = model.childrenAge
			self.roomsQuantity = model.roomsQuantity
		}
	}

	private struct CodableDestination: Codable {
		let id: Int
		let type: String
		let name: String
		let label: String
		let country: String
		let cityName: String

		var model: Destination {
			Destination(
				id: id,
				type: type,
				name: name,
				label: label,
				country: country,
				cityName: cityName
			)
		}

		init(model: Destination) {
			self.id = model.id
			self.type = model.type
			self.name = model.name
			self.label = model.label
			self.country = model.country
			self.cityName = model.cityName
		}
	}

	private let queue = DispatchQueue(label: "\(CodableHotelsSearchCriteriaStore.self)Queue")

	private let storeURL: URL

	public init(storeURL: URL) {
		self.storeURL = storeURL
	}

	public func save(_ criteria: HotelsSearchCriteria, completion: @Sendable @escaping (SaveResult) -> Void) {
		queue.async {
			do {
				let data = try JSONEncoder().encode(CodableSearchCriteria(model: criteria))
				try data.write(to: self.storeURL, options: [.atomic])
				completion(.success(()))
			} catch {
				completion(.failure(error))
			}
		}
	}

	public func save(_ criteria: HotelsSearchCriteria) async throws {
		let data = try JSONEncoder().encode(CodableSearchCriteria(model: criteria))
		try data.write(to: self.storeURL, options: [.atomic])
	}

	public func retrieve() async throws -> HotelsSearchCriteria {
		do {
			let data = try Data(contentsOf: self.storeURL)
			let criteria = try JSONDecoder().decode(CodableSearchCriteria.self, from: data)
			return criteria.model
		} catch let error as NSError where error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
			throw SearchCriteriaError.notFound
		}
	}
}
