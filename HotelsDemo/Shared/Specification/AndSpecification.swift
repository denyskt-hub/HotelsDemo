//
//  AndSpecification.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public struct AndSpecification<S: Specification>: Specification {
	public typealias Item = S.Item

	private let lhs: S
	private let rhs: S

	public init(lhs: S, rhs: S) {
		self.lhs = lhs
		self.rhs = rhs
	}

	public func isSatisfied(by item: S.Item) -> Bool {
		lhs.isSatisfied(by: item) && rhs.isSatisfied(by: item)
	}
}
