//
//  UnlockNotesView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 13/05/24.
//

import SwiftUI

/// View to authenticate and show locked notes.
struct UnlockNotesView: View {
    /// State that authorizes access to private notes.
    @Environment(PrivateNotesAccessState.self) private var privateNotesAccess
    
    var body: some View {
        VStack {
            Image(systemName: "lock.circle.fill")
                .foregroundStyle(.accent.gradient)
                .font(.system(size: 50))
                .padding()
            
            Text("Private notes are protected")
                .font(.title2)
                .bold()
            
            Text("Unlock to enable access")
                .foregroundStyle(.secondary)
            
            Button("Unlock") {
                privateNotesAccess.authenticate(for: .viewNotes) { }
            }
            .padding()
        }
        .accessibilityElement()
    }
}

extension UnlockNotesView {
    /// Adapted UnlockNotesView for VoiceOver users.
    var accessibilityUnlockNotesView: some View {
        Button {
            privateNotesAccess.authenticate(for: .viewNotes) { }
        } label: {
            UnlockNotesView()
        }
        .accessibilityLabel("Private notes are protected. Tap to enable access.")
    }
}
