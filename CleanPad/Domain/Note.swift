//
//  Note.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import Foundation

struct Note: Codable, Identifiable {
    var id = UUID()
    var isLocked = false
    var date = Date.now
    
    var title = ""
    var textContent = ""
    
    static let example = Note(
        date: .now,
        title: "This is an example note",
        textContent: "Hello, world! 🌎"
    )
}
