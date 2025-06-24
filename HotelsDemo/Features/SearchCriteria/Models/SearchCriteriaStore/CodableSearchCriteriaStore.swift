//
//  CodableSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

final class CodableSearchCriteriaStore: SearchCriteriaStore {
	private struct CodableSearchCriteria: Codable {
		var destination: CodableDestination?
		let checkInDate: Date
		let checkOutDate: Date
		let adults: Int
		let childrenAge: [Int]
		let roomsQuantity: Int

		var model: SearchCriteria {
			SearchCriteria(
				destination: destination?.model,
				checkInDate: checkInDate,
				checkOutDate: checkOutDate,
				adults: adults,
				childrenAge: childrenAge,
				roomsQuantity: roomsQuantity
			)
		}

		init(model: SearchCriteria) {
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

	private let queue = DispatchQueue(label: "\(CodableSearchCriteriaStore.self)Queue")

	private let storeURL: URL
	private let dispatcher: Dispatcher

	init(storeURL: URL, dispatcher: Dispatcher) {
		self.storeURL = storeURL
		self.dispatcher = dispatcher
	}

	func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void) {
		_save(criteria) { error in
			self.dispatcher.dispatch {
				completion(error)
			}
		}
	}

	private func _save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void) {
		queue.async {
			do {
				let data = try JSONEncoder().encode(CodableSearchCriteria(model: criteria))
				try data.write(to: self.storeURL)
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}

	func retrieve(completion: @escaping (SearchCriteriaStore.Result) -> Void) {
		_retrieve { result in
			self.dispatcher.dispatch {
				completion(result)
			}
		}
	}

	func _retrieve(completion: @escaping (SearchCriteriaStore.Result) -> Void) {
		queue.async {
			guard FileManager.default.fileExists(atPath: self.storeURL.path) else {
				return completion(.success(.default))
			}

			do {
				let data = try Data(contentsOf: self.storeURL)
				let criteria = try JSONDecoder().decode(CodableSearchCriteria.self, from: data)
				completion(.success(criteria.model))
			} catch {
				completion(.failure(error))
			}
		}
	}
}
