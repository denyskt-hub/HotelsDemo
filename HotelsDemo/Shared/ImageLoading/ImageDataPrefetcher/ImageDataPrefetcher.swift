//
//  ImageDataPrefetcher.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/12/25.
//

import Foundation

public protocol ImageDataPrefetcher: Sendable {
	func prefetch(urls: [URL])
	func cancelPrefetching(urls: [URL])
}
