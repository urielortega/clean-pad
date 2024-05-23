//
//  TextFieldStyles.swift
//  CleanPad
//
//  Created by Uriel Ortega on 23/05/24.
//

import Foundation
import SwiftUI

struct GradientTextFieldStyle: TextFieldStyle {
    var startColor: Color
    var endColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [startColor, endColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 10))
            .shadow(
                color: .customTextFieldShadow,
                radius: 2,
                x: 0,
                y: 6
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        Material.ultraThinMaterial,
                        lineWidth: 3
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
