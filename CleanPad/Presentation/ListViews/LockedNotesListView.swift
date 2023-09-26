//
//  LockedNotesListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

struct LockedNotesListView: View {
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    @State private var showEditViewSheet = false

    var body: some View {
        Group {
            if viewModel.isUnlocked {
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
            } else {
                Button("Unlock Notes") {
                    viewModel.authenticate(for: .viewNotes)
                }
                .padding()
                .background(.brown)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .navigationTitle("Personal")
        .toolbar {
            if viewModel.isUnlocked {
                HStack {
                    Button {
                        // TODO: Lock notes.
                        viewModel.lockNotes()
                    } label: {
                        Label("Lock notes", systemImage: "lock.open.fill")
                    }
                    
                    Button {
                        showEditViewSheet.toggle()
                    } label: {
                        Label("Create note", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showEditViewSheet) {
            // NoteEditView with a blank locked Note:
            NoteEditView(note: Note(isLocked: true), creatingNewNote: true)
        }
        
    }
}
