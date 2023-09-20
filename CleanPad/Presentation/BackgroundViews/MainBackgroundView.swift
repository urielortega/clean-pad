//
//  MainBackgroundView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

struct MainBackgroundView: View {
    var body: some View {
        Color.brown
            .opacity(0.15)
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}
