//
//  ButtonsViews.swift
//  CleanPad
//
//  Created by Uriel Ortega on 29/09/23.
//

import Foundation
import SwiftUI

/// Button to definitely delete a note, with optional view dismissal.
struct DeleteNoteButton: View {
    var note: Note
    @ObservedObject var viewModel: NotesListViewModel
    var dismissView: Bool

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(role: .destructive) {
            if dismissView {
                dismiss()
                
                // Delete note after delay.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.delete(note: note)
                    }
                }
            } else {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewModel.delete(note: note)
                }
            }
        } label: {
            Label("Delete note", systemImage: "trash.fill")
        }
    }
}

struct DismissViewButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(
            "Dismiss",
            systemImage: "xmark.circle.fill",
            action: { dismiss() }
        )
        .imageScale(.large)
        .labelStyle(.iconOnly)
        .foregroundStyle(.background, .primary.opacity(0.4))
        .padding(.horizontal)
    }
}
