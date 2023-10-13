//
//  LockedNotesListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

/// View that contains locked notes, and let users tap a note to view and edit it.
struct LockedNotesListView: View {
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    @State private var showEditViewSheet = false
    @State private var isAnimating = false

    var body: some View {
        Group {
            if viewModel.isUnlocked {
                if viewModel.lockedNotes.isEmpty {
                    EmptyListView(
                        imageSystemName: "note.text",
                        label: "This looks a little empty...",
                        description: viewModel.placeholders.randomElement() ?? "Start writing...",
                        buttonLabel: "Create a note!"
                    ) {
                        showEditViewSheet.toggle()
                    }
                    .padding(.bottom, 100)
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
                                .contextMenu {
                                    // Button to change isLocked note property, i.e., remove it from the personal space.
                                    Button {
                                        viewModel.updateLockStatus(for: note)
                                    } label: {
                                        Label("Remove from personal space", systemImage: "lock.open.fill")
                                    }
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
    
    /// Button to authenticate and show locked notes list.
    var unlockNotesButtonView: some View {
        Button("Unlock Notes") {
            viewModel.authenticate(for: .viewNotes) {  }
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
    
    /// Button to hide locked notes list.
    var lockNotesButtonView: some View {
        Button {
            viewModel.lockNotes()
        } label: {
            Label("Lock notes", systemImage: "lock.open.fill")
        }
    }
}
