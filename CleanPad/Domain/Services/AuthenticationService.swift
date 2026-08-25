//
//  AuthenticationService.swift
//  CleanPad
//
//  Created by Uriel Ortega on 22/08/26.
//

import Foundation

/// Capability used by the app to verify the user's identity before showing or changing private notes.
protocol AuthenticationService: Sendable {
    /// Requests authentication for the provided user-facing reason.
    func authenticate(reason: String) async throws
}

/// Domain-level authentication failures exposed to presentation code.
enum AuthenticationServiceError: LocalizedError {
    case unsupportedDevice
    case authenticationFailed
    case canceled
    case biometricsUnavailable
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unsupportedDevice:
            "Sorry, your device does not support authentication."
        case .authenticationFailed:
            "Authentication failed. Please try again."
        case .canceled:
            "Authentication canceled."
        case .biometricsUnavailable:
            "Biometrics not available or not enrolled. Use passcode instead."
        case .unknown:
            "Authentication error. Try again later."
        }
    }
}
