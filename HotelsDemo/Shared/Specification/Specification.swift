//
//  Specification.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public protocol Specification: Sendable {
	associatedtype Item

	func isSatisfied(by item: Item) -> Bool
}

public extension Specification {
	func and(_ other: Self) -> AndSpecification<Self> {
		AndSpecification(lhs: self, rhs: other)
	}

	func or(_ other: Self) -> OrSpecification<Self> {
		OrSpecification(lhs: self, rhs: other)
	}
}
