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
    
    /// Strings shown when a list is empty to invite the user to create a note.
    static let emptyListPlaceholders = [
        "What's on your mind?",
        "How's been your day?",
        "How are you feeling right now?",
        "It's OK. Write it down.",
        "Make today a little bit better.",
        "Let the words flow.",
        "Capture the moment.",
        "Start the symphony of thoughts."
    ]
    
    /// Strings shown when a note is untitled to invite the user to title it.
    static let untitledNotePlaceholders = [
        "Title your note...",
        "Title your imagination...",
        "Title your inspiration..."
    ]
    
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
