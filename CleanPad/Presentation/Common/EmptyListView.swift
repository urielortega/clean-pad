//
//  EmptyListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 10/10/23.
//
// Inspired by ContentUnavailableView (iOS 17+)

import SwiftUI

/// View meant to be used when a list is empty, inviting the user to add an item.
/// Can be personalized modifying its default parameters values.
struct EmptyListView: View {
    @Binding var showNoteEditViewSheet: Bool
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

extension EmptyListView {
    /// Adapted EmptyListView for VoiceOver users.
    var accessibilityEmptyListButton: some View {
        Button {
            showNoteEditViewSheet.toggle()
        } label: {
            EmptyListView(
                showNoteEditViewSheet: $showNoteEditViewSheet,
                imageSystemName: "note.text",
                label: "This looks a little empty...",
                description: Constants.emptyListPlaceholders.randomElement() ?? "Start writing...",
                buttonLabel: "Create a note!"
            ) {}
        }
        .accessibilityLabel("Empty list. Tap to create a note.")
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView(showNoteEditViewSheet: .constant(false)) { }
    }
}
