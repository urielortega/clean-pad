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
                    NoteLabelView(note: note)
                }
            }
            .onDelete(perform: viewModel.removeNonLockedNoteFromList)
        }
    }
}
