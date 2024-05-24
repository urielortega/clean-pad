//
//  HelperViews.swift
//  CleanPad
//
//  Created by Uriel Ortega on 17/10/23.
//

import SwiftUI

struct CustomHStackDivider: View {
    var width: Double = 2
    var height: Double = 30
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundStyle(.secondary)
    }
}

/// View to display a Custom Title at the top leading corner.
struct CustomTopTitle: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title)
                .bold()
            
            Spacer()
        }
    }
}
