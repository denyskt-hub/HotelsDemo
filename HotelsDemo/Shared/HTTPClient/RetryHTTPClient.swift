//
//  RetryHTTPClient.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14.06.2026.
//

import Foundation

/// Decorator that retries *transient transport failures* (timeouts, dropped
/// connections, DNS/host hiccups) with exponential backoff. It never retries
/// non-transport errors, HTTP status failures, or cancellation — those are
/// either deterministic or the caller's intent, so retrying would only waste
/// time. Placed below the auth decorator, so each attempt reuses the already
/// header-stamped request, and above logging, so every attempt is logged.
public final class RetryHTTPClient: HTTPClient {
	private let client: HTTPClient
	private let maxRetries: Int
	private let sleep: @Sendable (TimeInterval) async throws -> Void

	public init(
		client: HTTPClient,
		maxRetries: Int = 2,
		sleep: @Sendable @escaping (TimeInterval) async throws -> Void = {
			try await Task.sleep(nanoseconds: UInt64($0 * 1_000_000_000))
		}
	) {
		self.client = client
		self.maxRetries = maxRetries
		self.sleep = sleep
	}

	public func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		var attempt = 0
		while true {
			do {
				return try await client.perform(request)
			} catch {
				attempt += 1
				guard attempt <= maxRetries, Self.isTransient(error) else {
					throw error
				}
				try await sleep(Self.backoff(forAttempt: attempt))
			}
		}
	}

	/// Exponential backoff: 0.5s, 1s, 2s, …
	private static func backoff(forAttempt attempt: Int) -> TimeInterval {
		0.5 * pow(2, Double(attempt - 1))
	}

	private static func isTransient(_ error: Error) -> Bool {
		guard let urlError = error as? URLError else { return false }
		switch urlError.code {
		case .timedOut,
			 .networkConnectionLost,
			 .cannotConnectToHost,
			 .cannotFindHost,
			 .dnsLookupFailed:
			return true
		default:
			return false
		}
	}
}
