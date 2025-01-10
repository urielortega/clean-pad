//
//  ShadowViewModifiers.swift
//  CleanPad
//
//  Created by Uriel Ortega on 09/01/25.
//

import SwiftUI

struct SoftShadow: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 2, x: 0, y: 4)
    }
}

extension View {
    func softShadow(color: Color) -> some View {
        modifier(SoftShadow(color: color))
    }
}

struct SubtleShadow: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 2, x: 0, y: 2)
    }
}

extension View {
    func subtleShadow(color: Color) -> some View {
        modifier(SubtleShadow(color: color))
    }
}

struct LargeShadow: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 8, x: 0, y: 4)
    }
}

extension View {
    func largeShadow(color: Color) -> some View {
        modifier(LargeShadow(color: color))
    }
}

struct GeneralButtonShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color(.sRGBLinear, white: 0, opacity: 0.14),
                radius: Constants.generalButtonShadowRadius
            )
    }
}

extension View {
    func generalButtonShadow() -> some View {
        modifier(GeneralButtonShadow())
    }
}
