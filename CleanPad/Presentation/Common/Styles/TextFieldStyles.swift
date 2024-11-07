//
//  TextFieldStyles.swift
//  CleanPad
//
//  Created by Uriel Ortega on 23/05/24.
//

import Foundation
import SwiftUI

/// A custom `TextFieldStyle` that applies a gradient background, rounded corners, and a soft shadow to a text field.
///
/// The `GradientTextFieldStyle` struct creates a stylized text field with a gradient background transitioning
/// between `startColor` and `endColor`. The gradient starts at the top leading corner and ends at the bottom trailing corner.
///
/// The style also includes rounded corners, a soft shadow, and an overlay with a gradient stroke border.
struct GradientTextFieldStyle: TextFieldStyle {
    var startColor: Color
    var endColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .fontWeight(.medium)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [startColor, endColor.opacity(Constants.gradientEndColorOpacity)]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: Constants.materialButtonCornerRadius))
            .softShadow(color: .customTextFieldShadow)
            .overlay {
                RoundedRectangle(cornerRadius: Constants.materialButtonCornerRadius)
                    .stroke(
                        endColor.gradient.opacity(0.5),
                        lineWidth: 4
                    )
                    .allowsHitTesting(false)
            }
    }
}

#Preview {
    TextField("Enter text..", text: .constant(""))
        .padding()
        .textFieldStyle(
            GradientTextFieldStyle(
                startColor: .clear,
                endColor: .brown
            )
        )
}
