//
//  NetworkError.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11.02.2026.
//

import Foundation

public enum NetworkError: Error {
	case noInternet
	case cannotConnect
	case unknown(Error)
}
