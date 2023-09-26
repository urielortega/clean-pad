//
//  NonLockedNotesListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

struct NonLockedNotesListView: View {
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.notes.filter { $0.isLocked == false }) { note in
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
                }
                
            }
            .onDelete(perform: viewModel.removeNonLockedNoteFromList)
        }
    }
}
