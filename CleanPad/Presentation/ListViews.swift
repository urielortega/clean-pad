//
//  ListViews.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/09/23.
//

import SwiftUI

struct MainNotesListView: View {
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @Binding var showEditViewSheet: Bool

    var body: some View {
        Form {
            // Locked notes section.
            Section {
                NavigationLink {
                    LockedNotesListView(viewModel: viewModel)
                } label: {
                    Label("Personal notes", systemImage: "lock.fill")
                        .foregroundColor(.brown)
                }
            }
            
            // Non-locked notes section.
            Section {
                if viewModel.notes.filter({ $0.isLocked == false }).isEmpty {
                    EmptyListView(
                        viewModel: viewModel,
                        showEditViewSheet: $showEditViewSheet
                    )
                } else {
                    NonLockedNotesListView(viewModel: viewModel)
                }
            }
        }
    }
}

struct LockedNotesListView: View {
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    @State private var showEditViewSheet = false

    var body: some View {
        Group {
            if viewModel.notes.filter({ $0.isLocked }).isEmpty {
                EmptyListView(
                    viewModel: viewModel,
                    showEditViewSheet: $showEditViewSheet
                )
            } else {
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
                    .onDelete(perform: viewModel.removeLockedNoteFromList)
                }
            }
        }
        .navigationTitle("Personal")
        .toolbar {
            Button {
                showEditViewSheet.toggle()
            } label: {
                Label("Create note", systemImage: "plus")
            }
        }
        .sheet(isPresented: $showEditViewSheet) {
            // NoteEditView with a blank locked Note:
            NoteEditView(note: Note(isLocked: true), creatingNewNote: true)
        }
        
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
            .onDelete(perform: viewModel.removeNonLockedNoteFromList)
        }
    }
}
