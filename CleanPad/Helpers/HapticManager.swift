//
//  HapticManager.swift
//  CleanPad
//
//  Created by Uriel Ortega on 23/10/23.
//

import SwiftUI

/// A custom singleton class to manage haptic feedback throughout the app.
/// Provides easy-to-use methods for generating notification and impact haptic feedback.
class HapticManager {
    /// Shared instance of `HapticManager` to enable global access to haptic feedback methods.
    static let instance = HapticManager()
    
    /// Triggers a notification-style haptic feedback.
    /// Use this method to give the user tactile feedback in response to significant actions or changes.
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    /// Triggers an impact-style haptic feedback.
    /// Use this method to give the user a subtle tactile response, ideal for smaller, less significant actions.
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
