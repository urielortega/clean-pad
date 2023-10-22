//
//  Note.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import Foundation

/// Main model in the app defining a note structure.
struct Note: Codable, Identifiable, Equatable {
    var id = UUID()
    
    /// Property that indicates whether a note is personal (locked) or not.
    var isLocked = false
    
    var date = Date.now
    
    var title = ""
    var textContent = ""
    
    /// Example note for previews and testing.
    static let example = Note(
        date: .now,
        title: "This is an example note",
        textContent: "Hello, world! 🌎"
    )
}
