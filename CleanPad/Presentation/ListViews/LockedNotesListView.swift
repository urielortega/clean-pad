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
    @State private var isAnimating = false

    var body: some View {
        Group {
            if viewModel.isUnlocked {
                if viewModel.lockedNotes.isEmpty {
                    PlaceholderView(
                        viewModel: viewModel,
                        showEditViewSheet: $showEditViewSheet
                    )
                } else {
                    List {
                        ForEach(viewModel.lockedNotes) { note in
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
                        .onDelete(perform: viewModel.removeLockedNoteFromList)
                    }
                }
            } else {
                unlockNotesButtonView
            }
        }
        .navigationTitle("Personal")
        .toolbar {
            if viewModel.isUnlocked {
                HStack {
                    lockNotesButtonView
                    if !(viewModel.lockedNotes.isEmpty) {
                        CreateNoteButtonView(showEditViewSheet: $showEditViewSheet) // Only shown when the list isn't empty.
                    }
                }
            }
        }
        .sheet(isPresented: $showEditViewSheet) {
            // NoteEditView with a blank locked Note:
            NoteEditView(note: Note(isLocked: true), viewModel: viewModel, creatingNewNote: true)
        }
    }
    
    var unlockNotesButtonView: some View {
        Button("Unlock Notes") {
            viewModel.authenticate(for: .viewNotes)
        }
        .padding()
        .frame(width: 200, height: 50)
        .background(.brown)
        .foregroundColor(.white)
        .fontWeight(.medium)
        .clipShape(Capsule())
        .opacity(isAnimating ? 0.6 : 1.0)
        .onAppear {
            DispatchQueue.main.async {
                // Using withAnimation() to avoid unintentional movement:
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
        }
    }
    
    var lockNotesButtonView: some View {
        Button {
            viewModel.lockNotes()
        } label: {
            Label("Lock notes", systemImage: "lock.open.fill")
        }
    }
}
