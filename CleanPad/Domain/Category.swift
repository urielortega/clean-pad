//
//  Category.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/02/24.
//

import Foundation
import SwiftUI

/// Model defining the Note Category structure.
struct Category: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var color: Color
}

extension Category {
    static let example = Category(
        name: "Thoughts",
        color: .cyan
    )
    
    // Static variable representing the default note category: General.
    static var general = Category(name: "General", color: .gray)
}
