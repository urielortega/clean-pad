//
//  Constants.swift
//  CleanPad
//
//  Created by Uriel Ortega on 27/11/23.
//

import Foundation

enum Constants {
    enum AuthenticationReason {
        case viewNotes, changeLockStatus
    }
    
    enum Tab {
        case nonLockedNotes, lockedNotes
    }
    
    /// Path used to store ``notes`` with documents directory.
    static let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedNotes")
    
    /// Path used to store ``categories`` with documents directory.
    static let categoriesPath = FileManager.documentsDirectory.appendingPathComponent ("SavedCategories")
    
    // MARK: - UI-related properties.
    
    static let textShadowRadius: CGFloat = 8
    static let iconShadowRadius: CGFloat = 8
    static let generalButtonShadowRadius: CGFloat = 8
    static let roundedRectCornerRadius: CGFloat = 22
    
    // MARK: Dock
    
    static let dockGlowInactiveShadowRadius: CGFloat = 8
    static let dockGlowDarkModeShadowRadius: CGFloat = 16
    static let dockGlowLightModeShadowRadius: CGFloat = 20
    static let dockGlowInactiveShadowOpacity: Double = 0.14
    static let dockGlowDarkModeShadowOpacity: Double = 0.24
    static let dockGlowLightModeShadowOpacity: Double = 0.34
    static let dockGlowBeamHeight: CGFloat = 120
    static let dockGlowBeamDarkModeBlurRadius: CGFloat = 28
    static let dockGlowBeamLightModeBlurRadius: CGFloat = 20
    static let dockGlowBeamTopOpacity: Double = 0
    static let dockGlowBeamDarkModeMiddleOpacity: Double = 0.10
    static let dockGlowBeamLightModeMiddleOpacity: Double = 0.18
    static let dockGlowBeamDarkModeBottomOpacity: Double = 0.24
    static let dockGlowBeamLightModeBottomOpacity: Double = 0.34
    static let dockGlowBeamTopLocation: CGFloat = 0
    static let dockGlowBeamMiddleLocation: CGFloat = 0.48
    static let dockGlowBeamBottomLocation: CGFloat = 1
    
    static let appIconCornerRadius: CGFloat = 22
    static let materialButtonCornerRadius: CGFloat = 16 // Used in Buttons and TextFields related to Categories.
    static let gradientStartColorOpacity: Double = 0.8 // Used in Buttons and TextFields related to Categories.
    static let gradientEndColorOpacity: Double = 0.5 // Used in Buttons and TextFields related to Categories.
}
