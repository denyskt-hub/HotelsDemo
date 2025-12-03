//
//  ImageDataPrefetcherDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/12/25.
//

import Foundation

public protocol ImageDataPrefetcherDelegate: AnyObject, Sendable {
	func imageDataPrefetcher(_ prefetcher: ImageDataPrefetcher, willPrefetchDataForURL url: URL)
	func imageDataPrefetcher(_ prefetcher: ImageDataPrefetcher, didPrefetchDataForURL url: URL)
}
