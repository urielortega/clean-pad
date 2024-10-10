//
//  EmptyListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 10/10/23.
//

import SwiftUI

/// View meant to be used when a list is empty, inviting the user to add an item.
/// Can be personalized modifying its default parameters values.
struct EmptyListView: View {
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    @Binding var showNoteEditViewSheet: Bool
    
    var imageSystemName: String = "questionmark"
    var label: String = "No Items"
    var description: String = "Start adding items to your list."
    var buttonLabel: String = "Add item"
    
    /// Local State property for managing the creation of a new note.
    @State private var newNote = Note()
    
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
            
            Button(buttonLabel) { //                               Non-locked note with General Category.     Locked note with General Category.
                newNote = (viewModel.isNonLockedNotesTabSelected) ? Note(category: viewModel.categories[0]) : Note(isLocked: true, category: viewModel.categories[0])
                
                buttonActions()
            }
        }
        .sheet(isPresented: $showNoteEditViewSheet) {
            // Open NoteEditView with a new Note:
            NoteEditView(
                note: newNote,
                viewModel: viewModel,
                sheetsViewModel: sheetsViewModel,
                creatingNewNote: true
            )
        }

    }
}

extension EmptyListView {
    /// Adapted EmptyListView for VoiceOver users.
    var accessibilityEmptyListButton: some View {
        Button { //                                             Non-locked note with General Category.     Locked note with General Category.
            newNote = (viewModel.isNonLockedNotesTabSelected) ? Note(category: viewModel.categories[0]) : Note(isLocked: true, category: viewModel.categories[0])
            showNoteEditViewSheet.toggle()
        } label: {
            EmptyListView(
                viewModel: viewModel,
                sheetsViewModel: sheetsViewModel,
                showNoteEditViewSheet: $showNoteEditViewSheet,
                imageSystemName: "note.text",
                label: "This looks a little empty...",
                description: Constants.emptyListPlaceholders.randomElement() ?? "Start writing...",
                buttonLabel: "Create a note!"
            ) { }
        }
        .accessibilityLabel("Empty list. Tap to create a note.")
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView(
            viewModel: NotesListViewModel(),
            sheetsViewModel: SheetsViewModel(),
            showNoteEditViewSheet: .constant(false)
        ) { }
    }
}
