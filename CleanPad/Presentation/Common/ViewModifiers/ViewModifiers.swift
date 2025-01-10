//
//  ViewModifiers.swift
//  CleanPad
//
//  Created by Uriel Ortega on 17/10/23.
//

import SwiftUI

// MARK: - Dock ViewModifiers

/// A modifier that styles a view as a dock, applying background, corner radius, shadow, and padding.
/// This modifier is used to create a dock that spans the full width and optionally displays buttons.
struct Dock: ViewModifier {
    @ObservedObject var viewModel: NotesListViewModel

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: Constants.roundedRectCornerRadius))
            .roundedRectangleOverlayStroke()
            .glowingShadow(viewModel: viewModel)
            .padding(.vertical)
            .padding(.horizontal, viewModel.showingDockButtons ? 0 : 10)
    }
}

extension View {
    func dockStyle(viewModel: NotesListViewModel) -> some View {
        modifier(Dock(viewModel: viewModel))
    }
}

enum DockButtonPosition {
    case left, right
}

/// A modifier that styles a button for placement within the dock, adding background, corner radius, and shadow.
/// The button can be aligned to either the left or right side of the dock.
struct DockButton: ViewModifier {
    let position: DockButtonPosition

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 55)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: Constants.roundedRectCornerRadius))
            .roundedRectangleOverlayStroke()
            .generalButtonShadow()
            .padding(((position == .left) ? .leading : .trailing), 10)
    }
}

extension View {
    func dockButtonStyle(position: DockButtonPosition) -> some View {
        modifier(DockButton(position: position))
    }
}

/// A modifier that adds a glowing shadow to the dock, giving visual emphasis when a category is selected.
/// The shadow color and radius vary based on the dock's glowing state.
struct GlowingShadow: ViewModifier {
    @ObservedObject var viewModel: NotesListViewModel

    func body(content: Content) -> some View {
        content
            .shadow(
                color: getGlowingShadowColor(),
                radius: viewModel.isDockGlowing ? 16 : 8
            )
    }
    
    /// Determines the color of the glowing shadow based on the selected category and dock state.
    func getGlowingShadowColor() -> Color {
        if (viewModel.isDockGlowing && viewModel.isSomeCategorySelected) {
            viewModel.selectedCategory.color.opacity(0.7)
        } else {
            Color(.sRGBLinear, white: 0, opacity: 0.14)
        }
    }
}

extension View {
    func glowingShadow(viewModel: NotesListViewModel) -> some View {
        modifier(GlowingShadow(viewModel: viewModel))
    }
}

// MARK: - Stroke ViewModifiers

struct RoundedRectangleOverlayStroke: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: Constants.roundedRectCornerRadius)
                    .stroke(.gray.gradient.opacity(0.1), lineWidth: 3)
            }
    }
}

extension View {
    func roundedRectangleOverlayStroke() -> some View {
        modifier(RoundedRectangleOverlayStroke())
    }
}

// MARK: - Accessibility ViewModifiers

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

struct SoftShadow: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 2, x: 0, y: 4)
    }
}

// MARK: - Shadow ViewModifiers

extension View {
    func softShadow(color: Color) -> some View {
        modifier(SoftShadow(color: color))
    }
}

struct SubtleShadow: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 2, x: 0, y: 2)
    }
}

extension View {
    func subtleShadow(color: Color) -> some View {
        modifier(SubtleShadow(color: color))
    }
}

struct LargeShadow: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 8, x: 0, y: 4)
    }
}

extension View {
    func largeShadow(color: Color) -> some View {
        modifier(LargeShadow(color: color))
    }
}

struct GeneralButtonShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color(.sRGBLinear, white: 0, opacity: 0.14),
                radius: Constants.generalButtonShadowRadius
            )
    }
}

extension View {
    func generalButtonShadow() -> some View {
        modifier(GeneralButtonShadow())
    }
}
