//
//  ImageView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import UIKit

public protocol ImageView: AnyObject {
	func displayImage(_ image: UIImage)
	func displayPlaceholderImage(_ image: UIImage)
	func displayLoading(_ isLoading: Bool)
}
