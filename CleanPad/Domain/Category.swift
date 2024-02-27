//
//  Category.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/02/24.
//

import Foundation
import SwiftUI

/// Model defining the Note Category structure.
struct Category: Codable, Identifiable, Equatable, Hashable {
    var id: UUID
    var name: String
    var color: Color
}

extension Category {
    // Static variable representing the default note category: General.
    static var general = Category(
        id: UUID(uuidString: "6EDDFE8C-0489-4455-9010-75D2D2A7BD37")!, // Static id for the permanent General Category.
        name: "General",
        color: .brown
    )
    
    static let example = Category(
        id: UUID(),
        name: "Thoughts",
        color: .cyan
    )
    
    static let emptySelection = Category(
        id: UUID(), 
        name: "No selection",
        color: .clear
    )
}
