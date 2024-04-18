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

struct BorderedButtonLabel: View {
    let color: Color
    let labelText: String
    let systemImageString: String
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundStyle(color)
                .frame(height: 50)
                .frame(minWidth: 300, maxWidth: .infinity)
                .overlay {
                    Capsule()
                        .stroke(color.gradient, lineWidth: 3)
                }
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.14), radius: 8)

            Label(labelText, systemImage: systemImageString)
                .labelStyle(.automatic)
                .foregroundStyle(.white)
                .fontWeight(.medium)
        }
    }
}
