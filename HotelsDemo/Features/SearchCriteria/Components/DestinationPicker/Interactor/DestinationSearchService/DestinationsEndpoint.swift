//
//  DestinationsEndpoint.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/7/25.
//

import Foundation

public enum DestinationsEndpoint {
	case searchDestination

	public func url(_ baseURL: URL) -> URL {
		switch self {
		case .searchDestination:
			var components = URLComponents()
			components.scheme = baseURL.scheme
			components.host = baseURL.host
			components.port = baseURL.port
			components.path = baseURL.path + "/api/v1/hotels/searchDestination"
			return components.url!
		}
	}
}
