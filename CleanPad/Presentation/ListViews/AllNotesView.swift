//
//  AllNotesView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 03/11/23.
//

import SwiftUI

/// View that shows non-locked and locked notes, and let users tap a note to view and edit it.
struct AllNotesView: View {
    // Using the viewModels created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var dateViewModel: DateViewModel
    
    @Binding var showEditViewSheet: Bool
    
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    var body: some View {
        Group {
            if viewModel.isLockedNotesTabSelected && !viewModel.isUnlocked {
                unlockNotesView
                    .padding(.bottom, 80)
            } else {
                if viewModel.currentNotes.isEmpty {
                    if voiceOverEnabled {
                        accessibilityEmptyListButton
                    } else {
                        EmptyListView(
                            imageSystemName: "note.text",
                            label: "This looks a little empty...",
                            description: Constants.emptyListPlaceholders.randomElement() ?? "Start writing...",
                            buttonLabel: "Create a note!"
                        ) {
                            showEditViewSheet.toggle()
                        }
                        .padding(.bottom, 80)
                    }
                } else {
                    if viewModel.idiom == .pad || viewModel.isGridViewSelected {
                        notesGridView
                    } else {
                        notesListView
                    }
                }
            }
        }
    }
    
    /// View that shows notes as rows in a single column.
    var notesListView: some View {
        Group {
            if viewModel.filteredNotes.isEmpty {
                ContentUnavailableView.search
            } else {
                List {
                    ForEach(viewModel.filteredNotes) { note in
                        NavigationLink {
                            // Open NoteEditView with the tapped note.
                            NoteEditView(
                                note: note,
                                viewModel: viewModel,
                                creatingNewNote: false
                            )
                        } label: {
                            ListNoteLabel(note: note, viewModel: dateViewModel)
                        }
                        .contextMenu {
                            ContextMenuButtons(note: note, viewModel: viewModel)
                        } preview: {
                            ContextMenuPreview(note: note)
                        }
                    }
                    // To avoid unexpected list behavior, note removal is forbidden when making a search.
                    .onDelete(
                        perform: viewModel.searchText.isEmpty ? viewModel.removeNoteFromList : nil
                    )
                }
                .safeAreaInset(edge: .bottom) {
                    // View to prevent CustomTabBar from hiding the List.
                    Spacer()
                        .frame(height: 80)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Look for a note...")
    }
    
    /// View that shows notes as a grid with multiple columns.
     var notesGridView: some View {
         let layout = [
            GridItem(
                .adaptive(minimum: viewModel.idiom == .pad ? 200 : 160)
            )
         ]
         
         return Group {
             if viewModel.filteredNotes.isEmpty {
                 ContentUnavailableView.search
             } else {
                 ScrollView {
                     LazyVGrid(columns: layout) {
                         ForEach(viewModel.filteredNotes) { note in
                             NavigationLink {
                                 // Open NoteEditView with the tapped note.
                                 NoteEditView(
                                    note: note,
                                    viewModel: viewModel,
                                    creatingNewNote: false
                                 )
                             } label: {
                                 GridNoteLabel(note: note, viewModel: dateViewModel)
                                     .padding(5)
                             }
                             .contextMenu {
                                 ContextMenuButtons(note: note, viewModel: viewModel)
                             } preview: {
                                 ContextMenuPreview(note: note)
                             }
                         }
                     }
                     .padding()
                     .padding(.bottom, 60) // Padding to prevent CustomTabBar from hiding the List.
                 }
             }
         }
         .searchable(text: $viewModel.searchText, prompt: "Look for a note...")
     }
    
    /// Button to authenticate and show locked notes list.
    var unlockNotesView: some View {
        VStack {
            Image(systemName: "lock.circle.fill")
                .foregroundStyle(.accent.gradient)
                .font(.system(size: 50))
                .padding()
            
            Text("These notes are protected")
                .font(.title2)
                .bold()
            
            Text("Unlock to enable access")
                .foregroundStyle(.secondary)
            
            Button("Unlock") {
                withAnimation {
                    viewModel.authenticate(for: .viewNotes) {  }
                }
            }
            .padding()
        }
    }
    
    var accessibilityEmptyListButton: some View {
        Button {
            showEditViewSheet.toggle()
        } label: {
            EmptyListView(
                imageSystemName: "note.text",
                label: "This looks a little empty...",
                description: Constants.emptyListPlaceholders.randomElement() ?? "Start writing...",
                buttonLabel: "Create a note!"
            ) {}
        }
        .accessibilityLabel("Empty list. Tap to create a note.")
    }
}
