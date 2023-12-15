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
        "Make today a little bit better."
    ]
    
    /// Path used to store ``notes`` with documents directory.
    static let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedNotes")
}
