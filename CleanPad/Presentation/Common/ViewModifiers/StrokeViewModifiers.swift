//
//  StrokeViewModifiers.swift
//  CleanPad
//
//  Created by Uriel Ortega on 09/01/25.
//

import SwiftUI

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
