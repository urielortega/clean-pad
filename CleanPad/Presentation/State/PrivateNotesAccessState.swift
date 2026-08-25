//
//  PrivateNotesAccessState.swift
//  CleanPad
//
//  Created by Uriel Ortega on 22/08/26.
//

import Observation
import SwiftUI

/// Access state and authorization flow for private notes.
///
/// `PrivateNotesAccessState` owns the private-notes access flags, authentication errors,
/// and the authorization flow required before viewing private notes or changing a note's lock status.
@MainActor
@Observable
final class PrivateNotesAccessState {
    /// Service used to request identity verification before private-note actions.
    @ObservationIgnored private let authenticationService: any AuthenticationService
    
    init(authenticationService: any AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    /// Indicates whether access to private notes is currently unlocked.
    private(set) var isUnlocked = false
    
    /// Indicates whether changing a note's lock status is currently permitted.
    private(set) var areChangesAllowed = false
    
    /// Last authentication error message shown to the user.
    private(set) var authenticationError = "Unknown error"
    
    /// Controls the authentication error alert on the main screen.
    var isShowingAuthenticationErrorOnMainScreen = false
    
    /// Controls the authentication error alert while editing a note.
    var isShowingAuthenticationErrorWhenEditing = false
}

// MARK: - Access Control Methods:

extension PrivateNotesAccessState {
    /// Authenticates the user and updates the matching private-notes permission state.
    ///
    /// - Parameters:
    ///   - authenticationReason: Determines whether authentication unlocks private notes or allows lock-status changes.
    ///   - successAction: Closure called after successful authentication and state update.
    func authenticate(
        for authenticationReason: Constants.AuthenticationReason,
        successAction: @escaping @MainActor () -> Void
    ) {
        Task { @MainActor in
            do {
                try await authenticationService.authenticate(reason: authenticationPromptReason)
                handleSuccessfulAuthentication(for: authenticationReason, successAction: successAction)
            } catch {
                handleFailedAuthentication(error, for: authenticationReason)
            }
        }
    }
    
    /// User-facing reason shown by the system authentication prompt.
    private var authenticationPromptReason: String {
        "Please authenticate yourself to lock and unlock your notes data."
    }
    
    /// Applies the permission changes associated with a successful authentication.
    private func handleSuccessfulAuthentication(
        for authenticationReason: Constants.AuthenticationReason,
        successAction: @MainActor () -> Void
    ) {
        withAnimation(.bouncy) {
            if authenticationReason == .viewNotes {
                isUnlocked = true
            } else if authenticationReason == .changeLockStatus {
                areChangesAllowed = true
            }
            successAction()
        }
    }
    
    /// Stores the authentication error and opens the alert used by the active flow.
    private func handleFailedAuthentication(
        _ error: Error,
        for authenticationReason: Constants.AuthenticationReason
    ) {
        authenticationError = error.localizedDescription
        
        if authenticationReason == .viewNotes {
            isShowingAuthenticationErrorOnMainScreen = true
        } else if authenticationReason == .changeLockStatus {
            isShowingAuthenticationErrorWhenEditing = true
        }
    }
    
    /// Locks private notes again.
    func lockNotes() {
        isUnlocked = false
    }
    
    /// Revokes permission to change note lock status.
    func forbidChanges() {
        areChangesAllowed = false
    }
}
