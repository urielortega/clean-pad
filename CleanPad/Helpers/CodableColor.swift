//
//  CodableColor.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/02/24.
//

import Foundation
import SwiftUI

/// Extension to make SwiftUI's `Color` conform to `Codable`,
/// allowing it to be encoded and decoded for storage or data transfer.
extension Color: Codable {
    /// Coding keys for extracting RGB components of a color.
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }
    
    /// Initializes a `Color` instance by decoding its RGB components.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        
        self.init(red: r, green: g, blue: b)
    }
    
    /// Encodes a `Color` instance by storing its RGB components.
    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.colorComponents else {
            return
        }
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }
}

fileprivate extension Color {
    /// Helper property that extracts the RGB and alpha components of a `Color`.
    /// Returns `nil` if the color cannot be converted into RGB format.
    ///
    /// Note: Colors using hue, saturation, and brightness may not work.
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // Attempt to convert the color into RGB format.
        // If conversion fails, `nil` is returned.
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        return (r, g, b, a)
    }
}
