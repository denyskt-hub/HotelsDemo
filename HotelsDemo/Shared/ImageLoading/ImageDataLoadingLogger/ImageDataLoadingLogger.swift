//
//  ImageDataLoadingLogger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 7/8/25.
//

import Foundation

public protocol ImageDataLoadingLogger: Sendable {
	func log(loadResult result: Result<Data, Error>, for url: URL)
}
