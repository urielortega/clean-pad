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
    
    var title = ""
    var textContent = ""
}
