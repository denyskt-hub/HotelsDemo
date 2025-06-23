//
//  UICollectionView+Register.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

extension UICollectionView {
	func register<T: UICollectionViewCell>(_ cellType: T.Type) {
		let identifier = String(describing: cellType)
		register(cellType, forCellWithReuseIdentifier: identifier)
	}
}
