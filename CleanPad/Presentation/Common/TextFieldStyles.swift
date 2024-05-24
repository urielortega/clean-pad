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
            .fontWeight(.medium)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [startColor, endColor.opacity(0.8)]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 10))
            .softShadow(color: .customTextFieldShadow)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        endColor.gradient.opacity(0.5),
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
