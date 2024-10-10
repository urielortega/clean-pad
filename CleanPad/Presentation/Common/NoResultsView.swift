//
//  NoResultsView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 09/10/24.
// Inspired by ContentUnavailableView (iOS 17+)

import SwiftUI

/// A custom alternative to SwiftUI's ContentUnavailableView (iOS 17+), designed for a more personalized and expressive "No Results" display.
struct NoResultsView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.system(size: 50))
                .padding(.bottom)
            
            Text("No Results")
                .font(.title2)
                .bold()
                .padding(.bottom, 3)
            
            Text("Check the spelling, try a new search or choose another category.")
                .multilineTextAlignment(.center)
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.bottom, 15)
        }
    }
}

#Preview {
    NoResultsView()
}
