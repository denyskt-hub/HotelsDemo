//
//  ImageDataLoadingLogger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 7/8/25.
//

import Foundation

public protocol ImageDataLoadingLogger {
	func log(loadResult result: ImageDataLoader.LoadResult, for url: URL)
}
