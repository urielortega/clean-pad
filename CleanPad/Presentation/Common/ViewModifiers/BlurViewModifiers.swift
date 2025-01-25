//
//  BlurViewModifiers.swift
//  CleanPad
//
//  Created by Uriel Ortega on 09/01/25.
//

import SwiftUI

/// ViewModifier to blur a view when the app is inactive and the `isBlurActive` flag is set to `true`.
struct BlurWhenAppNotActive: ViewModifier {
    /// A boolean flag that determines whether the blur effect should be applied.
    let isBlurActive: Bool
    
    /// Property to blur locked notes when phase changes.
    @Environment(\.scenePhase) private var scenePhase
 
    func body(content: Content) -> some View {
        content
            .blur(radius: ((scenePhase != .active) && isBlurActive) ? 10 : 0)
            .animation(.default, value: scenePhase)
    }
}

extension View {
    public func blurWhenAppNotActive(isBlurActive: Bool) -> some View {
        modifier(BlurWhenAppNotActive(isBlurActive: isBlurActive))
    }
}
