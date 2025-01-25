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
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    @Binding var showNoteEditViewSheet: Bool
    
    /// Property to adapt the UI for VoiceOver users.
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    var body: some View {
        Group {
            if viewModel.isLockedNotesTabSelected && !viewModel.isUnlocked {
                Group {
                    if voiceOverEnabled {
                        UnlockNotesView(viewModel: viewModel).accessibilityUnlockNotesView
                    } else {
                        UnlockNotesView(viewModel: viewModel)
                    }
                }
                .padding(.bottom, 80)
            } else {
                if viewModel.currentNotes.isEmpty {
                    Group {
                        if voiceOverEnabled {
                            EmptyListView(
                                viewModel: viewModel,
                                sheetsViewModel: sheetsViewModel,
                                showNoteEditViewSheet: $showNoteEditViewSheet,
                                buttonActions: { }
                            )
                            .accessibilityEmptyListButton
                        } else {
                            EmptyListView(
                                viewModel: viewModel,
                                sheetsViewModel: sheetsViewModel,
                                showNoteEditViewSheet: $showNoteEditViewSheet,
                                imageSystemName: "note.text",
                                label: "This looks a little empty...",
                                buttonLabel: "Create a note!"
                            ) { showNoteEditViewSheet.toggle() }
                        }
                    }
                    .padding(.bottom, 80)
                } else {
                    Group {
                        if viewModel.idiom == .pad || viewModel.isGridViewSelected {
                            notesGridView
                        } else {
                            notesListView
                        }
                    }
                    .blurWhenAppNotActive( // Apply blur when access to private notes is allowed and Private Notes Tab is selected.
                        isBlurActive: viewModel.isUnlocked  && viewModel.isLockedNotesTabSelected
                    )
                }
            }
        }
    }
}

// MARK: - Extension to group secondary views in AllNotesView.
extension AllNotesView {
    /// View that shows notes as rows in a single column.
    var notesListView: some View {
        Group {
            if viewModel.filteredNotes.isEmpty {
                NoResultsView()
            } else {
                List {
                    ForEach(viewModel.filteredNotes) { note in
                        NavigationLink {
                            // Open NoteEditView with the tapped note.
                            NoteEditView(
                                note: note,
                                viewModel: viewModel,
                                sheetsViewModel: sheetsViewModel,
                                creatingNewNote: false
                            )
                        } label: {
                            ListNoteLabel(note: note, viewModel: dateViewModel)
                        }
                        .contextMenu {
                            NoteContextMenuButtons(note: note, viewModel: viewModel)
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
                NoResultsView()
            } else {
                ScrollView {
                    LazyVGrid(columns: layout) {
                        ForEach(viewModel.filteredNotes) { note in
                            NavigationLink {
                                // Open NoteEditView with the tapped note.
                                NoteEditView(
                                    note: note,
                                    viewModel: viewModel,
                                    sheetsViewModel: sheetsViewModel,
                                    creatingNewNote: false
                                )
                            } label: {
                                GridNoteLabel(note: note, viewModel: dateViewModel)
                                    .padding(5)
                            }
                            .contextMenu {
                                NoteContextMenuButtons(note: note, viewModel: viewModel)
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
}
