//
//  LocalAuthenticationService.swift
//  CleanPad
//
//  Created by Uriel Ortega on 22/08/26.
//

import Foundation
import LocalAuthentication

/// `AuthenticationService` implementation backed by Apple's LocalAuthentication framework.
struct LocalAuthenticationService: AuthenticationService {
    func authenticate(reason: String) async throws {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            throw AuthenticationServiceError.unsupportedDevice
        }
        
        try await withCheckedThrowingContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: mapAuthenticationError(error))
                }
            }
        }
    }
    
    /// Converts framework-specific errors into app-level authentication errors.
    private func mapAuthenticationError(_ error: Error?) -> AuthenticationServiceError {
        guard let error else { return .unknown }
        
        switch LAError(_nsError: error as NSError).code {
        case .authenticationFailed:
            return .authenticationFailed
        case .userCancel, .userFallback:
            return .canceled
        case .biometryNotAvailable, .biometryNotEnrolled:
            return .biometricsUnavailable
        default:
            return .unknown
        }
    }
}
