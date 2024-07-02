//
//  ButtonStyles.swift
//  CleanPad
//
//  Created by Uriel Ortega on 10/06/24.
//

import Foundation
import SwiftUI

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
    }
}
