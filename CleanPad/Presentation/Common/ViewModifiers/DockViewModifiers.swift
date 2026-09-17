//
//  DockViewModifiers.swift
//  CleanPad
//
//  Created by Uriel Ortega on 17/10/23.
//

import SwiftUI

fileprivate extension View {
    
    /// Applies the dock background using Liquid Glass on iOS 26 and later, falling back to the legacy material.
    /// - Parameter isInteractive: A Boolean value that controls whether the Liquid Glass surface reacts to touch and pointer input.
    @ViewBuilder
    func dockGlassBackground(isInteractive: Bool = false) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(
                isInteractive ? .regular.interactive() : .regular,
                in: .rect(cornerRadius: Constants.roundedRectCornerRadius)
            )
        } else {
            self
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: Constants.roundedRectCornerRadius))
        }
    }

    /// Preserves the legacy dock stroke before iOS 26 while avoiding fixed borders over Liquid Glass.
    @ViewBuilder
    func dockOverlayStroke() -> some View {
        if #available(iOS 26.0, *) {
            self
        } else {
            self.roundedRectangleOverlayStroke()
        }
    }

}

/// A modifier that styles a view as the central dock surface.
///
/// On iOS 26 and later, the modifier uses Liquid Glass and can opt into interactive glass behavior.
/// On earlier versions, it preserves the app's original material, clipping, stroke, shadow, and padding.
struct Dock: ViewModifier {
    var viewModel: MainScreenViewModel
    let isPrivateAccessUnlocked: Bool
    let isInteractive: Bool

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .dockGlassBackground(isInteractive: isInteractive)
            .dockOverlayStroke()
            .glowingShadow(viewModel: viewModel)
            .padding(.vertical)
            .padding(.horizontal, viewModel.showingDockButtons(isPrivateAccessUnlocked: isPrivateAccessUnlocked) ? 0 : 10)
    }
}

extension View {
    func dockStyle(
        viewModel: MainScreenViewModel,
        isPrivateAccessUnlocked: Bool,
        isInteractive: Bool = false
    ) -> some View {
        modifier(
            Dock(
                viewModel: viewModel,
                isPrivateAccessUnlocked: isPrivateAccessUnlocked,
                isInteractive: isInteractive
            )
        )
    }
}

/// Horizontal placement for a secondary dock button.
enum DockButtonPosition {
    case left, right
}

/// A modifier that styles a secondary dock button.
///
/// On iOS 26 and later, the button uses interactive Liquid Glass. On earlier versions,
/// it preserves the original material, stroke, shadow, and side padding.
struct DockButton: ViewModifier {
    let position: DockButtonPosition

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 55)
            .dockGlassBackground(isInteractive: true)
            .dockOverlayStroke()
            .generalButtonShadow()
            .padding(((position == .left) ? .leading : .trailing), 10)
    }
}

extension View {
    func dockButtonStyle(position: DockButtonPosition) -> some View {
        modifier(DockButton(position: position))
    }
}

/// A modifier that adds a glowing shadow to the dock, giving visual emphasis when a category is selected.
/// The shadow color and radius vary based on the dock's glowing state.
struct GlowingShadow: ViewModifier {
    var viewModel: MainScreenViewModel

    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .shadow(
                color: getGlowingShadowColor(),
                radius: getGlowingShadowRadius()
            )
    }
    
    /// Determines the color of the glowing shadow based on the selected category and dock state.
    func getGlowingShadowColor() -> Color {
        if (viewModel.isDockGlowing && viewModel.isSomeCategorySelected) {
            viewModel.selectedCategory.color.opacity(getGlowingShadowOpacity())
        } else {
            Color(.sRGBLinear, white: 0, opacity: Constants.dockGlowInactiveShadowOpacity)
        }
    }

    /// Uses stronger shadow feedback in Light Mode and a softer glow in Dark Mode.
    func getGlowingShadowOpacity() -> Double {
        colorScheme == .dark ? Constants.dockGlowDarkModeShadowOpacity : Constants.dockGlowLightModeShadowOpacity
    }

    /// Keeps the glow concentrated around the dock while improving visibility in Light Mode.
    func getGlowingShadowRadius() -> CGFloat {
        guard viewModel.isDockGlowing else { return Constants.dockGlowInactiveShadowRadius }
        return colorScheme == .dark ? Constants.dockGlowDarkModeShadowRadius : Constants.dockGlowLightModeShadowRadius
    }
}

extension View {
    func glowingShadow(viewModel: MainScreenViewModel) -> some View {
        modifier(GlowingShadow(viewModel: viewModel))
    }
}
