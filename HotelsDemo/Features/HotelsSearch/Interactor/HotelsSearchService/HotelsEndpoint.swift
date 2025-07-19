//
//  HotelsEndpoint.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import Foundation

public enum HotelsEndpoint {
	case searchHotels

	public func url(_ baseURL: URL) -> URL {
		switch self {
		case .searchHotels:
			var components = URLComponents()
			components.scheme = baseURL.scheme
			components.host = baseURL.host
			components.port = baseURL.port
			components.path = baseURL.path + "/api/v1/hotels/searchHotels"
			return components.url!
		}
	}
}
