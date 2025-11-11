//
//  ImageDataPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import Foundation

@MainActor
public protocol ImageDataPresentationLogic: Sendable {
	func presentImageData(_ data: Data)
	func presentImageDataError(_ error: Error)
	func presentLoading(_ isLoading: Bool)
}
