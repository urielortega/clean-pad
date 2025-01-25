//
//  ConditionalViewModifier.swift
//  CleanPad
//
//  Created by Uriel Ortega on 25/01/25.
//

import SwiftUI

extension View {
    /// Applies a modifier conditionally
    @ViewBuilder
    func modifierIf<Content: View>(_ condition: Bool, _ modifier: (Self) -> Content) -> some View {
        if condition { modifier(self) } else { self }
    }
}
