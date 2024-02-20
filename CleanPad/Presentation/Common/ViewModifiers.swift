//
//  ViewModifiers.swift
//  CleanPad
//
//  Created by Uriel Ortega on 17/10/23.
//

import SwiftUI

struct Dock: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray.gradient.opacity(0.1), lineWidth: 3)
            }
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.14), radius: 8)
            .padding(.vertical)
    }
}

extension View {
    func dockStyle() -> some View {
        modifier(Dock())
    }
}

enum DockButtonPosition {
    case left, right
}

struct DockButton: ViewModifier {
    let position: DockButtonPosition

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 55)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray.gradient.opacity(0.1), lineWidth: 3)
            }
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.14), radius: 8)
            .padding(((position == .left) ? .leading : .trailing), 10)
    }
}

extension View {
    func dockButtonStyle(position: DockButtonPosition) -> some View {
        modifier(DockButton(position: position))
    }
}


struct NoteLabelAccessibilityModifiers: ViewModifier {
    var note: Note
    @ObservedObject var viewModel: DateViewModel
    
    func body(content: Content) -> some View {
        content
            .accessibilityElement()
            .accessibilityLabel(note.isLocked ? "Private note: \(note.noteTitle)" : "Note: \(note.noteTitle)")
            .accessibilityHint(
                viewModel.isNoteDateEqualToToday(note: note)
                ? "Created at \(note.date.formatted(date: .omitted, time: .shortened))"
                : "Created on \(note.date.formatted(date: .abbreviated, time: .omitted))"
            )
    }
}

extension View {
    func noteLabelAccessibilityModifiers(note: Note, viewModel: DateViewModel) -> some View {
        modifier(NoteLabelAccessibilityModifiers(note: note, viewModel: viewModel))
    }
}
