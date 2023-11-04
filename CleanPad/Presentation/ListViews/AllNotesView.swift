//
//  AllNotesView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 03/11/23.
//

import SwiftUI

/// View that shows non-locked and locked notes, and let users tap a note to view and edit it.
struct AllNotesView: View {
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    @Binding var showEditViewSheet: Bool
    @State private var isAnimating = false

    @State private var searchText = ""

    var body: some View {
        Group {
            if viewModel.isLockedNotesTabSelected && !viewModel.isUnlocked {
                unlockNotesButtonView
            } else {
                if viewModel.currentNotes.isEmpty {
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
                    notesListView
                }
            }
        }
    }
    
    /// View that shows notes as rows in a single column.
    var notesListView: some View {
        VStack {
            Form {
                List {
                    ForEach(filteredNotes) { note in
                        NavigationLink {
                            // Open NoteEditView with the tapped note.
                            NoteEditView(note: note, viewModel: viewModel, creatingNewNote: false)
                        } label: {
                            ListNoteLabel(note: note, viewModel: viewModel)
                                .contextMenu {
                                    isLockedToggleButton(note: note, viewModel: viewModel)
                                }
                        }
                    }
                    /*
                     FIXME: onDelete doesn't work as expected.
                    .onDelete(
                        perform:
                            viewModel.isLockedNotesTabSelected ? viewModel.removeLockedNoteFromList : viewModel.removeNonLockedNoteFromList
                    )
                     */
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
    
    /// View that shows notes as a grid with multiple columns.
    // var notesGridView: some View {
        // TODO
    // }
    
    /// Button to change isLocked note property, i.e., remove it from or move it to personal space.
    struct isLockedToggleButton: View {
        var note: Note
        @ObservedObject var viewModel: NotesListViewModel
        
        var body: some View {
            Button {
                viewModel.updateLockStatus(for: note)
            } label: {
                Label(
                    viewModel.isLockedNotesTabSelected ? "Remove from personal space" : "Move to personal space",
                    systemImage: viewModel.isLockedNotesTabSelected ? "lock.slash.fill" : "lock.fill")
            }
        }
    }
    
    /// Computed property that returns a Note array with all notes or the ones resulting from a search.
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return viewModel.currentNotes.sorted { $0.date > $1.date } // Locked or non-locked notes, sorted by date.
        } else {
            return viewModel.currentNotes
                .sorted { $0.date > $1.date }
                .filter { // Returns notes that match the search field with its title or content.
                    $0.title.localizedCaseInsensitiveContains(searchText) || $0.textContent.localizedCaseInsensitiveContains(searchText)
                }
        }
    }
    
    /// Button to authenticate and show locked notes list.
    var unlockNotesButtonView: some View {
        Button {
            viewModel.authenticate(for: .viewNotes) {  }
        } label: {
            ZStack {
                Capsule()
                    .foregroundStyle(.brown)
                    .frame(width: 200, height: 50)

                Text("Unlock Notes")
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .opacity(isAnimating ? 0.8 : 1.0)
        .scaleEffect(isAnimating ? 0.95 : 1.0)
        .onAppear {
            DispatchQueue.main.async {
                // Using withAnimation() to avoid unintentional movement:
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
        }
    }
}
