//
//  AccessibilityViewModifiers.swift
//  CleanPad
//
//  Created by Uriel Ortega on 09/01/25.
//

import SwiftUI

/// A view modifier that configures accessibility labels and hints for a note label,
/// providing detailed information about the note's title, category, and creation date.
struct NoteLabelAccessibilityModifiers: ViewModifier {
    var note: Note
    @ObservedObject var viewModel: DateViewModel
    
    func body(content: Content) -> some View {
        content
            .accessibilityElement()
            .accessibilityLabel(
                (note.isLocked ? "Private note: \(note.noteTitle)," : "Note: \(note.noteTitle),")
                + "in the \(note.category?.displayName ?? "Unassigned") category."
            )
            .accessibilityHint(
                viewModel.isNoteDateEqualToToday(note: note)
                ? "Created at \(note.date.formatted(date: .omitted, time: .shortened))."
                : "Created on \(note.date.formatted(date: .abbreviated, time: .omitted))."
            )
    }
}

extension View {
    func noteLabelAccessibilityModifiers(note: Note, viewModel: DateViewModel) -> some View {
        modifier(NoteLabelAccessibilityModifiers(note: note, viewModel: viewModel))
    }
}

