//
//  WeakRefVirtualProxy.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit
import Foundation

public final class WeakRefVirtualProxy<T: AnyObject> {
	public weak var object: T?

	public init(object: T? = nil) {
		self.object = object
	}
}

extension WeakRefVirtualProxy: Routable where T: Routable {
	public func present(_ viewController: UIViewController) {
		object?.present(viewController)
	}

	public func show(_ viewController: UIViewController) {
		object?.show(viewController)
	}
}
