//
//  DismissViewButton.swift
//  CleanPad
//
//  Created by Uriel Ortega on 11/07/26.
//

import SwiftUI

/// A standard dismiss control for modal or pushed views.
///
/// This is a thin wrapper around `CloseActionButton` that invokes the SwiftUI
/// `dismiss()` environment action. It preserves clear semantics (this button is
/// specifically for dismissing the current view) while reusing the shared close
/// look & feel.
///
/// Behavior and accessibility:
/// - Inherits all behavior from `CloseActionButton`.
///   - iOS 26 and later: uses `Button(role: .close)` and adopts system styling and accessibility behaviors.
///   - Earlier iOS versions: falls back to an `xmark.circle.fill` icon-only button with a subtle foreground style.
struct DismissViewButton: View {
    @Environment(\.dismiss) private var dismiss
    private let accessibilityLabel: LocalizedStringKey

    /// Creates a dismiss button that closes the current view.
    /// - Parameter accessibilityLabel: The label announced by assistive technologies. Defaults to "Close".
    init(accessibilityLabel: LocalizedStringKey = "Close") {
        self.accessibilityLabel = accessibilityLabel
    }

    var body: some View {
        CloseActionButton(accessibilityLabel: accessibilityLabel) {
            dismiss()
        }
    }
}
