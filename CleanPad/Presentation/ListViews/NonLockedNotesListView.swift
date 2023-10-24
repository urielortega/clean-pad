//
//  NonLockedNotesListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

/// View that contains non-locked notes, and let users tap a note to view and edit it.
struct NonLockedNotesListView: View {
    @ObservedObject var viewModel: NotesListViewModel
    @Binding var showEditViewSheet: Bool
    
    @State private var searchText = ""
    
    var body: some View {
        if viewModel.nonLockedNotes.isEmpty {
            EmptyListView(
                imageSystemName: "note.text",
                label: "This looks a little empty...",
                description: viewModel.placeholders.randomElement() ?? "Start writing...",
                buttonLabel: "Create a note!"
            ) {
                showEditViewSheet.toggle()
            }
            .padding(.bottom, 80)
        } else {
            VStack {
                Form {
                    List {
                        ForEach(filteredNotes) { note in
                            NavigationLink {
                                // Open NoteEditView with the tapped note.
                                NoteEditView(note: note, viewModel: viewModel, creatingNewNote: false)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(note.title)
                                    Text(note.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .contextMenu {
                                    MoveToPersonalSpaceButton(note: note, viewModel: viewModel)
                                }
                            }
                        }
                        .onDelete(perform: viewModel.removeNonLockedNoteFromList)
                    }
                }
                
                if !viewModel.isKeyboardPresented {
                    // View to prevent CustomTabBar from hiding the List.
                    // Hidden when the system keyboard is shown.
                    Color.clear
                        .frame(height: 40)
                }
            }
            .searchable(text: $searchText, prompt: "Look for a note...")
        }
    }
    
    /// Button to change isLocked note property, i.e., move it to the personal space.
    struct MoveToPersonalSpaceButton: View {
        var note: Note
        @ObservedObject var viewModel: NotesListViewModel
        
        var body: some View {
            Button {
                viewModel.updateLockStatus(for: note)
            } label: {
                Label("Move to personal space", systemImage: "lock.open.fill")
            }
        }
    }
    
    /// Computed property that returns a Note array with all non-locked notes or the ones resulting from a search.
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return viewModel.nonLockedNotes // All nonLockedNotes.
        } else {
            return viewModel.nonLockedNotes.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) || $0.textContent.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
