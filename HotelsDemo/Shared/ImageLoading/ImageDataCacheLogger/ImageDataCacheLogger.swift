//
//  ImageDataCacheLogger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 7/8/25.
//

import Foundation
import ImageLoadingKit

public protocol ImageDataCacheLogger: Sendable {
	func log(saveResult: ImageDataCache.SaveResult, forKey key: String)
	func log(dataResult: ImageDataCache.DataResult, forKey key: String)
}
