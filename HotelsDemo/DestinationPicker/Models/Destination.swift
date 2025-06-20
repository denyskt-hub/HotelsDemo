//
//  Destination.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

struct Destination: Codable {
	let id: Int
	let type: String
	let name: String
	let label: String
	let country: String
	let cityName: String
}
