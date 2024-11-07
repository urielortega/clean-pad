//
//  ButtonStyles.swift
//  CleanPad
//
//  Created by Uriel Ortega on 10/06/24.
//

import Foundation
import SwiftUI

/// A custom `ButtonStyle` that applies a rounded rectangular shape, material background, and soft shadow to a button.
///
/// The button's opacity is slightly reduced when pressed for a subtle feedback effect.
struct MaterialRoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: Constants.materialButtonCornerRadius))
            .softShadow(color: .gridLabelShadow)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

/// A custom `ButtonStyle` that applies a circular shape, thin material background, and a shadow to a button.
///
/// The button's opacity is slightly reduced when pressed for a subtle feedback effect.
struct MaterialCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(.thinMaterial)
            .clipShape(Circle())
            .largeShadow(color: .black.opacity(0.3))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

/// A custom `ButtonStyle` that applies a gradient background, rounded corners, and soft shadow to a button.
///
/// `GradientButtonStyle` provides a button with a gradient background that transitions between `startColor` and `endColor`.
/// The button's opacity is slightly reduced when pressed for a subtle feedback effect.
struct GradientButtonStyle: ButtonStyle {
    var startColor: Color
    var endColor: Color
    var startColorOpacity = 1.0
    var endColorOpacity = Constants.gradientEndColorOpacity
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .fontWeight(.medium)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            startColor.opacity(startColorOpacity),
                            endColor.opacity(endColorOpacity)
                        ]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: Constants.materialButtonCornerRadius))
            .softShadow(color: .gradientButtonShadow)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}
