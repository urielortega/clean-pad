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
    
    // MARK: UI-related properties.
    static let textShadowRadius: CGFloat = 8
    static let iconShadowRadius: CGFloat = 8
    static let generalButtonShadowRadius: CGFloat = 8
    static let roundedRectCornerRadius: CGFloat = 22
    static let appIconCornerRadius: CGFloat = 22
    static let materialButtonCornerRadius: CGFloat = 16 // Used in Buttons and TextFields related to Categories.
    static let gradientStartColorOpacity: Double = 0.8 // Used in Buttons and TextFields related to Categories.
    static let gradientEndColorOpacity: Double = 0.5 // Used in Buttons and TextFields related to Categories.
}
