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
    
    var body: some View {
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
}
