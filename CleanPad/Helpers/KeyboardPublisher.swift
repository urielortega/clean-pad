//
//  KeyboardPublisher.swift
//  CleanPad
//
//  Created by Uriel Ortega on 23/10/23.
//

import Combine
import SwiftUI

extension View {
    /// Property used to monitor the visibility of the system keyboard.
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { _ in true },
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false })
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
