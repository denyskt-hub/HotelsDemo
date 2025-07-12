//
//  UITableView+Dequeueing.swift
//  DemoAppFeaturesiOS
//
//  Created by Denys Kotenko on 19/3/25.
//

import UIKit

extension UITableView {
	func dequeueReusableCell<T: UITableViewCell>() -> T {
		let identifier = String(describing: T.self)
		guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
			preconditionFailure("Failed to dequeue cell with identifier \(identifier) as \(T.self)")
		}
		return cell
	}
}
