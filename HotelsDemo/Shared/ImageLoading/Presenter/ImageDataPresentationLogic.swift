//
//  ImageDataPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import Foundation

public protocol ImageDataPresentationLogic {
	func presentImageData(_ data: Data)
	func presentImageDataError(_ error: Error)
}
