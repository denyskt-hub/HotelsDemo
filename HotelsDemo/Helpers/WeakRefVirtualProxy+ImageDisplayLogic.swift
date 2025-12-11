//
//  WeakRefVirtualProxy+ImageDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11/11/25.
//

import UIKit

extension WeakRefVirtualProxy: ImageDisplayLogic where T: ImageDisplayLogic {
	public func displayImage(_ image: UIImage) {
		object?.displayImage(image)
	}

	public func displayPlaceholderImage(_ image: UIImage) {
		object?.displayPlaceholderImage(image)
	}

	public func displayLoading(_ isLoading: Bool) {
		object?.displayLoading(isLoading)
	}
}
