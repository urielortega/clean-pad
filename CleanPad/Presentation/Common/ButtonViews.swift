//
//  ButtonViews.swift
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
                    withAnimation(.bouncy) {
                        viewModel.delete(note: note)
                    }
                }
            } else {
                withAnimation(.bouncy) {
                    viewModel.delete(note: note)
                }
            }
        } label: {
            Label("Delete note", systemImage: "trash.fill")
        }
    }
}

/// Button to definitely delete a category, with optional view dismissal.
struct DeleteCategoryButton: View {
    var category: Category
    @ObservedObject var viewModel: NotesListViewModel
    var dismissView: Bool

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(role: .destructive) {
            if dismissView {
                dismiss()
                
                // Delete category after delay:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.bouncy) { viewModel.delete(category: category) }
                }
            } else {
                withAnimation(.bouncy) { viewModel.delete(category: category) }
            }
        } label: {
            Label("Yes, delete this category", systemImage: "trash")
        }
    }
}


/// 'X' Button to dismiss a View.
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
    }
}

/// Bordered Capsule Button with customizable color, label and systemImage.
struct BorderedButtonLabel: View {
    let color: Color
    let labelText: String
    var systemImageString: String? = nil

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
                .generalButtonShadow()

            if systemImageString == nil { // When no systemImage is provided...
                Text(labelText) // ...use a Text View.
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
            } else {
                Label(labelText, systemImage: systemImageString!)
                    .labelStyle(.automatic)
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
            }
        }
    }
}

/// Thin Material Capsule Button with customizable label and systemImage.
struct MaterialButtonLabel: View {
    let labelText: String
    var systemImageString: String? = nil
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundStyle(Material.thin)
                .frame(height: 50)
                .frame(minWidth: 300, maxWidth: .infinity)
                .overlay {
                    Capsule()
                        .stroke(
                            Color.gray.gradient.opacity(0.3),
                            lineWidth: 3
                        )
                }
                .generalButtonShadow()

            if systemImageString == nil { // When no systemImage is provided...
                Text(labelText) // ...use a Text View.
                    .foregroundStyle(Color(.label))
                    .fontWeight(.medium)
            } else {
                Label(labelText, systemImage: systemImageString!)
                    .labelStyle(.automatic)
                    .foregroundStyle(Color(.label))
                    .fontWeight(.medium)
            }
        }
    }
}

/// Buttons to show when ContextMenu appears over a Note Label.
struct NoteContextMenuButtons: View {
    var note: Note
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        IsLockedToggleButton(
            note: note,
            viewModel: viewModel
        )
        ShareLink(item: "\(note.noteTitle)\n\(note.noteContent)")
        DeleteNoteButton(
            note: note,
            viewModel: viewModel,
            dismissView: false
        )
    }
}

/// Button to change isLocked note property, i.e., remove it from or move it to private space.
struct IsLockedToggleButton: View {
    var note: Note
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        Button {
            viewModel.updateLockStatus(for: note)
        } label: {
            Label(
                viewModel.isLockedNotesTabSelected ? "Remove from private space" : "Move to private space",
                systemImage: viewModel.isLockedNotesTabSelected ? "lock.slash.fill" : "lock.fill"
            )
        }
    }
}
