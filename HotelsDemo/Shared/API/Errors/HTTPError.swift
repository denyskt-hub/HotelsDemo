//
//  HTTPError.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/6/25.
//

import Foundation

public enum HTTPError: Error {
	case unexpectedStatusCode(Int)
}
