//
//  LabelStyles.swift
//  CleanPad
//
//  Created by Uriel Ortega on 03/09/26.
//

import SwiftUI

/// A label style that vertically centers an icon beside multiline text.
struct CenteredLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 6) {
            configuration.icon

            configuration.title
                .multilineTextAlignment(.leading)
        }
    }
}
