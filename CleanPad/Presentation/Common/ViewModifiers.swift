//
//  ViewModifiers.swift
//  CleanPad
//
//  Created by Uriel Ortega on 17/10/23.
//

import SwiftUI

struct Dock: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.30), radius: 15)
            .padding()
    }
}

extension View {
    func dockStyle() -> some View {
        modifier(Dock())
    }
}
