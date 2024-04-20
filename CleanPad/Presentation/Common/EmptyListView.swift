//
//  ContentUnavailableView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 10/10/23.
//
// Inspired by ContentUnavailableView (iOS 17+)

import SwiftUI

/// View meant to be used when a list is empty, inviting the user to add an item.
/// Can be personalized modifying its default parameters values.
struct EmptyListView: View {
    var imageSystemName: String = "questionmark"
    var label: String = "No Items"
    var description: String = "Start adding items to your list."
    var buttonLabel: String = "Add item"
    var buttonActions: () -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: imageSystemName)
                .foregroundStyle(.secondary)
                .font(.system(size: 50))
                .padding(.bottom)
            
            Text(label)
                .font(.title2)
                .bold()
                .padding(.bottom, 3)
            
            Text(description)
                .foregroundStyle(.secondary)
                .padding(.bottom, 15)
            
            Button(buttonLabel) {
                buttonActions()
            }
        }
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView() { }
    }
}
