//
//  AllNotesView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 03/11/23.
//

import SwiftUI

/// View that shows non-locked and locked notes, and let users tap a note to view and edit it.
struct AllNotesView: View {
    // Using the viewModels created in ContentView.
    @Bindable var viewModel: MainScreenViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    @Binding var showNoteEditViewSheet: Bool
    
    /// Property to adapt the UI for VoiceOver users.
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(NotesStore.self) private var notesStore
    @Environment(PrivateNotesAccessState.self) private var privateNotesAccess

    var body: some View {
        Group {
            if viewModel.isLockedNotesTabSelected && !privateNotesAccess.isUnlocked {
                Group {
                    if voiceOverEnabled {
                        UnlockNotesView().accessibilityUnlockNotesView
                    } else {
                        UnlockNotesView()
                    }
                }
                .padding(.bottom, 80)
            } else {
                if viewModel.currentNotes(from: notesStore.notes).isEmpty {
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
                        isBlurActive: privateNotesAccess.isUnlocked && viewModel.isLockedNotesTabSelected
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
            if viewModel.filteredNotes(from: notesStore.notes).isEmpty {
                NoResultsView()
            } else {
                List {
                    ForEach(viewModel.filteredNotes(from: notesStore.notes)) { note in
                        NavigationLink {
                            // Open NoteEditView with the tapped note.
                            NoteEditView(
                                note: note,
                                viewModel: viewModel,
                                sheetsViewModel: sheetsViewModel,
                                creatingNewNote: false
                            )
                        } label: {
                            ListNoteRow(note: note)
                        }
                        .listRowBackground(Rectangle().fill(.ultraThinMaterial))
                        .contextMenu {
                            NoteContextMenuButtons(note: note, viewModel: viewModel)
                        } preview: {
                            ContextMenuPreview(note: note)
                        }
                    }
                    // To avoid unexpected list behavior, note removal is forbidden when making a search.
                    .onDelete(
                        perform: viewModel.searchText.isEmpty ? deleteNotes : nil
                    )
                }
                .safeAreaInset(edge: .bottom) {
                    // View to prevent CustomTabBar from hiding the List.
                    Spacer()
                        .frame(height: 80)
                }
                .scrollContentBackground(.hidden)
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
            if viewModel.filteredNotes(from: notesStore.notes).isEmpty {
                NoResultsView()
            } else {
                ScrollView {
                    LazyVGrid(columns: layout) {
                        ForEach(viewModel.filteredNotes(from: notesStore.notes)) { note in
                            NavigationLink {
                                // Open NoteEditView with the tapped note.
                                NoteEditView(
                                    note: note,
                                    viewModel: viewModel,
                                    sheetsViewModel: sheetsViewModel,
                                    creatingNewNote: false
                                )
                            } label: {
                                GridNoteCard(note: note)
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
    
    func deleteNotes(at offsets: IndexSet) {
        viewModel.removeNoteFromList(at: offsets, in: notesStore)
    }
}
