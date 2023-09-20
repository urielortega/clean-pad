//
//  ListViews.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/09/23.
//

import SwiftUI

struct AllNotesListView: View {
    // Using the viewModel in a different view with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        Form {
            Section {
                NavigationLink {
                    // Opens another List, only for locked notes.
                    LockedNotesListView(viewModel: viewModel)
                } label: {
                    Label("Personal notes", systemImage: "lock.fill")
                        .foregroundColor(.brown)
                }
            }
            
            // For non-locked notes:
            NonLockedNotesListView(viewModel: viewModel)
        }
    }
}

struct LockedNotesListView: View {
    @ObservedObject var viewModel: NotesListViewModel

    var body: some View {
        List {
            ForEach(viewModel.notes.filter { $0.isLocked }) { note in
                NavigationLink {
                    // Open NoteEditView with the tapped note.
                    NoteEditView(note: note, creatingNewNote: false)
                } label: {
                    VStack(alignment: .leading) {
                        Text(note.title)
                        Text(note.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            // TODO: .onDelete()
        }
        .navigationTitle("Personal")
    }
}

struct NonLockedNotesListView: View {
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.notes.filter { $0.isLocked == false }) { note in
                NavigationLink {
                    // Open NoteEditView with the tapped note.
                    NoteEditView(note: note, creatingNewNote: false)
                } label: {
                    VStack(alignment: .leading) {
                        Text(note.title)
                        Text(note.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            // TODO: .onDelete()
        }
    }
}
