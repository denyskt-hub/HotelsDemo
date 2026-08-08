//
//  HotelsEndpoint.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import Foundation

public enum HotelsEndpoint {
	case searchHotels

	/// Appending to the base URL cannot fail, so composing an endpoint has no
	/// error case to invent. Whether `baseURL` is usable at all is decided once
	/// at launch by `Environment`, not re-litigated on every request.
	public func url(_ baseURL: URL) -> URL {
		switch self {
		case .searchHotels:
			return baseURL.appending(path: "api/v1/hotels/searchHotels")
		}
	}
}
