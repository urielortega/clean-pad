//
//  BackgroundColorView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

struct BackgroundColorView: View {
    var body: some View {
        Color.brown
            .opacity(0.15)
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

struct BackgroundColorView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundColorView()
    }
}
