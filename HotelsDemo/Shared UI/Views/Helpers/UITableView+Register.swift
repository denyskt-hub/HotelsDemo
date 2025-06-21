//
//  UITableView+Register.swift
//  DemoAppFeaturesiOS
//
//  Created by Denys Kotenko on 18/4/25.
//

import UIKit

extension UITableView {
	func register<T: UITableViewCell>(_ cellType: T.Type) {
		let identifier = String(describing: cellType)
		register(cellType, forCellReuseIdentifier: identifier)
	}
}
