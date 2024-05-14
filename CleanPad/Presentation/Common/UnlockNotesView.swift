//
//  UnlockNotesView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 13/05/24.
//

import SwiftUI

/// View to authenticate and show locked notes.
struct UnlockNotesView: View {
    @ObservedObject var viewModel: NotesListViewModel
    
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
                viewModel.authenticate(for: .viewNotes) {  }
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
            viewModel.authenticate(for: .viewNotes) {  }
        } label: {
            UnlockNotesView(viewModel: viewModel)
        }
        .accessibilityLabel("Private notes are protected. Tap to enable access.")
    }
}

#Preview {
    UnlockNotesView(viewModel: NotesListViewModel())
}
