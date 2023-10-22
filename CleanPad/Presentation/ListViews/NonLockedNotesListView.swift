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
                        ForEach(viewModel.nonLockedNotes) { note in
                            NavigationLink {
                                // Open NoteEditView with the tapped note.
                                NoteEditView(note: note, viewModel: viewModel, creatingNewNote: false)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(note.title)
                                    Text(note.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .contextMenu {
                                    // Button to change isLocked note property, i.e., move it to the personal space.
                                    Button {
                                        viewModel.updateLockStatus(for: note)
                                    } label: {
                                        Label("Move to personal space", systemImage: "lock.open.fill")
                                    }
                                }
                            }
                        }
                        .onDelete(perform: viewModel.removeNonLockedNoteFromList)
                    }
                }
                
                // View to prevent CustomTabBar from hiding the List.
                Color.clear
                    .frame(height: 40)
            }
        }
    }
}
