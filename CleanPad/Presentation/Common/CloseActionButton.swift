//
//  CloseActionButton.swift
//  CleanPad
//
//  Created by Uriel Ortega on 11/07/26.
//

import SwiftUI

/// A reusable “close” control rendered as an X icon that triggers a custom action.
///
/// Behavior:
/// - iOS 26 and later: Uses the system-provided close control via `Button(role: .close)`,
///   inheriting platform styling and accessibility behaviors.
/// - Earlier iOS versions: Falls back to a custom button with the `xmark.circle.fill` symbol,
///   using an icon-only label style and a subtle foreground style to approximate the system look.
///
/// Notes:
/// - Prefer this control for “close/abandon/exit” intents. If you need a dedicated dismiss of a view,
///   you can wrap this in a `DismissViewButton` that calls the SwiftUI `dismiss()` environment action.
struct CloseActionButton: View {
    private let action: () -> Void
    private let accessibilityLabel: LocalizedStringKey

    /// Creates a close action button.
    /// - Parameters:
    ///   - accessibilityLabel: The label announced by assistive technologies. Defaults to "Close".
    ///   - action: The action to perform when the button is tapped.
    init(
        accessibilityLabel: LocalizedStringKey = "Close",
        action: @escaping () -> Void
    ) {
        self.action = action
        self.accessibilityLabel = accessibilityLabel
    }

    var body: some View {
        if #available(iOS 26.0, *) {
            Button(role: .close) {
                action()
            }
            .accessibilityLabel(accessibilityLabel)
        } else {
            Button(
                "Close",
                systemImage: "xmark.circle.fill",
                action: action
            )
            .imageScale(.large)
            .labelStyle(.iconOnly)
            .foregroundStyle(.background, .primary.opacity(0.4))
            .accessibilityLabel(accessibilityLabel)
        }
    }
}
