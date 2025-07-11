//
//  UICollectionView+Dequeueing.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

extension UICollectionView {
	func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
		let identifier = String(describing: T.self)
		guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
			preconditionFailure("Failed to dequeue cell with identifier \(identifier) as \(T.self)")
		}
		return cell
	}

	func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T {
		let identifier = String(describing: T.self)
		guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? T else {
			preconditionFailure("Failed to dequeue view with identifier \(identifier) as \(T.self)")
		}
		return view
	}
}
