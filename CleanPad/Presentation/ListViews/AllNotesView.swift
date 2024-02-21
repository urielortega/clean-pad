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
    @State private var isAnimating = false
    
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    var body: some View {
        Group {
            if viewModel.isLockedNotesTabSelected && !viewModel.isUnlocked {
                unlockNotesButtonView
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
                        contextMenuButtons(note: note, viewModel: viewModel)
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
                             contextMenuButtons(note: note, viewModel: viewModel)
                         } preview: {
                             ContextMenuPreview(note: note)
                         }
                     }
                 }
                 .searchable(text: $viewModel.searchText, prompt: "Look for a note...")
                 .padding()
                 .padding(.bottom, 60) // Padding to prevent CustomTabBar from hiding the List.
             }
         }
     }
    
    struct contextMenuButtons: View {
        var note: Note
        @ObservedObject var viewModel: NotesListViewModel
        
        var body: some View {
            isLockedToggleButton(
                note: note,
                viewModel: viewModel
            )
            ShareLink(item: "\(note.noteTitle)\n\(note.noteContent)")
            DeleteNoteButton(
                note: note,
                viewModel: viewModel,
                dismissView: false
            )
        }
    }
    
    /// Button to change isLocked note property, i.e., remove it from or move it to private space.
    struct isLockedToggleButton: View {
        var note: Note
        @ObservedObject var viewModel: NotesListViewModel
        
        var body: some View {
            Button {
                viewModel.updateLockStatus(for: note)
            } label: {
                Label(
                    viewModel.isLockedNotesTabSelected ? "Remove from private space" : "Move to private space",
                    systemImage: viewModel.isLockedNotesTabSelected ? "lock.slash.fill" : "lock.fill"
                )
            }
        }
    }
    
    /// Button to authenticate and show locked notes list.
    var unlockNotesButtonView: some View {
        Button {
            withAnimation {
                HapticManager.instance.impact(style: .soft)
                viewModel.authenticate(for: .viewNotes) {  }
            }
        } label: {
            ZStack {
                Capsule()
                    .foregroundStyle(.accent)
                    .frame(width: 200, height: 50)
                    .overlay {
                        Capsule()
                            .stroke(.brown.gradient, lineWidth: 3)
                    }
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.14), radius: 8)

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
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
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
