//
//  AnySpecification.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/8/25.
//

import Foundation

public struct AnySpecification<Item>: Specification {
	private let isSatisfied: @Sendable (Item) -> Bool

	public init<S: Specification>(_ spec: S) where S.Item == Item {
		self.isSatisfied = spec.isSatisfied(by:)
	}

	public func isSatisfied(by item: Item) -> Bool {
		isSatisfied(item)
	}

	public func and(_ other: AnySpecification<Item>) -> AnySpecification<Item> {
		AnySpecification(AndSpecification(lhs: self, rhs: other))
	}

	public func or(_ other: AnySpecification<Item>) -> AnySpecification<Item> {
		AnySpecification(OrSpecification(lhs: self, rhs: other))
	}
}
