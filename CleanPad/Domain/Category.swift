//
//  Category.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/02/24.
//

import Foundation
import SwiftUI

/// Model representing a category that can be assigned to a note.
/// Each category has a unique identifier, a name, and an associated color for visual distinction.
struct Category: Codable, Identifiable, Equatable, Hashable {
    var id: UUID
    var name: String
    var color: Color
    
    var displayName: String {
        name.isEmpty ? "Unnamed" : name
    }
}

extension Category {
    // Static variable representing the default note category: General.
    static var general = Category(
        id: UUID(uuidString: "6EDDFE8C-0489-4455-9010-75D2D2A7BD37")!, // Static id for the permanent General Category.
        name: "General",
        color: .brown
    )
    
    static let noSelection = Category(
        id: UUID(uuidString: "0F8F3075-DCC8-4AC9-8FF4-19068D272AB8")!, // Static id for the permanent No Selection Category.
        name: "Show all notes",
        color: .gray
    )
}

#if DEBUG
extension Category {
    // MARK: Example categories:
    static let thoughts = Category(
        id: UUID(),
        name: "Thoughts",
        color: .cyan
    )
    
    static let health = Category(
        id: UUID(),
        name: "Health",
        color: .red
    )
    
    static let cleanPad = Category(
        id: UUID(),
        name: "CleanPad",
        color: .yellow
    )
    
    static let professional = Category(
        id: UUID(),
        name: "Professional",
        color: .indigo
    )
    
    static let business = Category(
        id: UUID(),
        name: "Business",
        color: .pink
    )

    
    static let personal = Category(
        id: UUID(),
        name: "Personal",
        color: .mint
    )
    
    static let screenshotsExamples: [Category] = [
        .thoughts,
        .health,
        .cleanPad,
        .professional,
        .business,
        .personal
    ]
}
#endif
