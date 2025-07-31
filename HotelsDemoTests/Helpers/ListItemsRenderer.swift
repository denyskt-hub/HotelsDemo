//
//  ListItemsRenderer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 31/7/25.
//

import UIKit

protocol ListItemsRenderer {
	func numberOfRenderedItems() -> Int
	func view(at index: Int) -> UIView?
}
