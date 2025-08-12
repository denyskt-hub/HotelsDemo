//
//  ImageDataCacheLogger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 7/8/25.
//

import Foundation

public protocol ImageDataCacheLogger {
	func log(saveResult: ImageDataCache.SaveResult, forKey key: String)
	func log(dataResult: ImageDataCache.DataResult, forKey key: String)
}
