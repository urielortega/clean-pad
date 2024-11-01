//
//  VariableBlur.swift
//  CleanPad
//
//  Created by Uriel Ortega on 28/09/24.
//  Code by Nikita Starshinov (https://github.com/nikstar).

import SwiftUI
import UIKit
import CoreImage.CIFilterBuiltins
import QuartzCore

/// Enum defining the direction of the variable blur effect.
public enum VariableBlurDirection {
    case blurredTopClearBottom
    case blurredBottomClearTop
}

/// A SwiftUI view that applies a variable blur effect, with adjustable blur radius
/// and direction. It bridges to UIKit's `UIVisualEffectView` to leverage Core Image filters.
///
/// - Parameters:
///   - maxBlurRadius: The maximum blur radius applied at the most blurred part of the view.
///   - direction: The direction of the blur transition, from top to bottom or vice versa.
///   - startOffset: An offset that adjusts the initial blur radius for smoother transitions.
public struct VariableBlurView: UIViewRepresentable {
    public var maxBlurRadius: CGFloat = 20
    
    public var direction: VariableBlurDirection = .blurredTopClearBottom
    
    /// By default, variable blur starts from 0 blur radius and linearly increases to `maxBlurRadius`. Setting `startOffset` to a small negative coefficient (e.g. -0.1) will start blur from larger radius value which might look better in some cases.
    public var startOffset: CGFloat = 0
    
    /// Initializes a `VariableBlurView` with customizable parameters.
    public init(maxBlurRadius: CGFloat = 20, direction: VariableBlurDirection = .blurredTopClearBottom, startOffset: CGFloat = 0) {
        self.maxBlurRadius = maxBlurRadius
        self.direction = direction
        self.startOffset = startOffset
    }
    
    public func makeUIView(context: Context) -> VariableBlurUIView {
        VariableBlurUIView(maxBlurRadius: maxBlurRadius, direction: direction, startOffset: startOffset)
    }

    public func updateUIView(_ uiView: VariableBlurUIView, context: Context) {
    }
}

/// A UIView subclass that applies a variable blur effect by using `CAFilter`.
/// This class leverages a gradient mask to adjust the blur radius across different parts of the view.
/// Credit https://github.com/jtrivedi/VariableBlurView
open class VariableBlurUIView: UIVisualEffectView {
    /// Initializes a `VariableBlurUIView` with a specific blur radius, direction, and offset.
    public init(maxBlurRadius: CGFloat = 20, direction: VariableBlurDirection = .blurredTopClearBottom, startOffset: CGFloat = 0) {
        super.init(effect: UIBlurEffect(style: .regular))

        // `CAFilter` is a private QuartzCore class dynamically created using Objective-C runtime.
        guard let CAFilter = NSClassFromString("CAFilter")! as? NSObject.Type else {
            print("[VariableBlur] Error: Can't find CAFilter class")
            return
        }
        guard let variableBlur = CAFilter.self.perform(NSSelectorFromString("filterWithType:"), with: "variableBlur").takeUnretainedValue() as? NSObject else {
            print("[VariableBlur] Error: CAFilter can't create filterWithType: variableBlur")
            return
        }

        // The blur radius at each pixel depends on the alpha value of the corresponding pixel in the gradient mask.
        // An alpha of 1 results in the max blur radius, while an alpha of 0 is completely unblurred.
        let gradientImage = makeGradientImage(startOffset: startOffset, direction: direction)

        variableBlur.setValue(maxBlurRadius, forKey: "inputRadius")
        variableBlur.setValue(gradientImage, forKey: "inputMaskImage")
        variableBlur.setValue(true, forKey: "inputNormalizeEdges")

        // We use a `UIVisualEffectView` here purely to get access to its `CABackdropLayer`,
        // which is able to apply various, real-time CAFilters onto the views underneath.
        let backdropLayer = subviews.first?.layer

        // Replace the standard filters (i.e. `gaussianBlur`, `colorSaturate`, etc.) with only the variableBlur.
        backdropLayer?.filters = [variableBlur]
        
        // Get rid of the visual effect view's dimming/tint view, so we don't see a hard line.
        for subview in subviews.dropFirst() {
            subview.alpha = 0
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Ensures correct rendering on high-resolution screens to fix pixelization at the edge of the blur.
    open override func didMoveToWindow() {
        // fixes visible pixelization at unblurred edge (https://github.com/nikstar/VariableBlur/issues/1)
        guard let window, let backdropLayer = subviews.first?.layer else { return }
        backdropLayer.setValue(window.screen.scale, forKey: "scale")
    }
    
    /// Override for trait collection changes; `super.traitCollectionDidChange` is omitted to avoid crashes.
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // `super.traitCollectionDidChange(previousTraitCollection)` crashes the app
    }
    
    /// Creates a gradient image to serve as a mask for the variable blur.
    private func makeGradientImage(width: CGFloat = 100, height: CGFloat = 100, startOffset: CGFloat, direction: VariableBlurDirection) -> CGImage { // much lower resolution might be acceptable
        let ciGradientFilter =  CIFilter.linearGradient()
        ciGradientFilter.color0 = CIColor.black
        ciGradientFilter.color1 = CIColor.clear
        ciGradientFilter.point0 = CGPoint(x: 0, y: height)
        ciGradientFilter.point1 = CGPoint(x: 0, y: startOffset * height) // small negative value looks better with vertical lines
        if case .blurredBottomClearTop = direction {
            ciGradientFilter.point0.y = 0
            ciGradientFilter.point1.y = height - ciGradientFilter.point1.y
        }
        return CIContext().createCGImage(ciGradientFilter.outputImage!, from: CGRect(x: 0, y: 0, width: width, height: height))!
    }
}
