//
//  NoteEditView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/09/23.
//

import SwiftUI

/// Enum for controlling the focus state when creating or editing a note.
fileprivate enum FocusField: Hashable {
    case titleTextField
    case textEditorField
}

/// View that shows a note content allowing the user to modify it, update it, save it and lock the note itself.
struct NoteEditView: View {
    @State var note: Note
    
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    /// Property to show Cancel and Save buttons, and handle `onChange` closures.
    @State var creatingNewNote: Bool
    
    /// Property that stores the focus of the current text field.
    @FocusState private var focusedField: FocusField?
    
    @Environment(\.dismiss) var dismiss
    
    /// Property to adapt the UI for VoiceOver users.
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    var body: some View {
        NavigationStack {
            // Show UnlockNotesView only when...
            if ( // ...access is locked, the note is private and it isn't a new one.
                !viewModel.isUnlocked && (note.isLocked == true) && !creatingNewNote
            ) {
                Group {
                    if voiceOverEnabled {
                        UnlockNotesView(viewModel: viewModel).accessibilityUnlockNotesView
                    } else {
                        UnlockNotesView(viewModel: viewModel)
                    }
                }
                .padding(.bottom, 80)
            } else {
                VStack {
                    titleTextFieldView
                    Divider()
                    textContentTextEditorView
                    Divider()
                    Button("Show categories") { sheetsViewModel.showNoteCategorySheet.toggle() }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if creatingNewNote {
                            Button("Cancel") { dismiss() }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            if !(focusedField == .none) {
                                // Button to dismiss keyboard when typing.
                                Button("OK") { focusedField = .none }
                            } else {
                                Menu {
                                    isLockedToggleButtonView
                                    if !creatingNewNote {
                                        ShareLink(item: "\(note.noteTitle)\n\(note.noteContent)")
                                        DeleteNoteButton(
                                            note: note,
                                            viewModel: viewModel,
                                            dismissView: true
                                        )
                                    }
                                    
                                } label: {
                                    Label("More options", systemImage: "ellipsis.circle")
                                }
                                if creatingNewNote {
                                    saveNoteButtonView
                                }
                            }
                        }
                    }
                }
                .sheet(isPresented: $sheetsViewModel.showNoteCategorySheet) {
                    NoteCategorySelectionView(
                        note: $note,
                        viewModel: viewModel,
                        sheetsViewModel: sheetsViewModel
                    )
                }
            }
        }
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
    }
}

// MARK: - Extension to group secondary views in NoteEditView.
extension NoteEditView {
    var titleTextFieldView: some View {
        TextField(
            note.noteTitle,
            text: $note.noteTitle,
            prompt: Text(
                Constants.untitledNotePlaceholders.randomElement() ?? "Title your note..."
            )
        )
        .font(.title2).bold()
        .padding(.leading)
        .onChange(of: note.noteTitle) {
            // When changing an existing note, save it while typing using update().
            if !creatingNewNote {
                viewModel.update(note: note)
            }
        }
        .focused($focusedField, equals: .titleTextField)
        .onAppear {
            if creatingNewNote { focusedField = .titleTextField }
        }
        .onSubmit { focusedField = .textEditorField }
        .submitLabel(.next)
    }
    
    var textContentTextEditorView: some View {
        TextEditor(text: $note.noteContent)
            .padding(.horizontal)
            .focused($focusedField, equals: .textEditorField)
            .onChange(of: note.noteContent) {
                // When changing an existing note, save it while typing using update().
                if !creatingNewNote {
                    viewModel.update(note: note)
                }
            }
    }
    
    /// Button to toggle `isLocked` property of a note, i.e., move it to or remove it from the private space.
    var isLockedToggleButtonView: some View {
        Button {
            if creatingNewNote {
                note.isLocked.toggle()
            } else {
                viewModel.updateLockStatus(for: note)
            }
        } label: {
            if creatingNewNote { // When creating a new note, Label responds to the State property.
                Label(
                    !note.isLocked ? "Move to private space" : "Remove from private space",
                    systemImage: !note.isLocked ? "lock.fill" : "lock.slash.fill"
                )
            } else {
                Label( // When editing an existing note, Label responds to the value of notes array (persistent storage).
                    !(viewModel.getNoteFromNotesArray(note: note)!.isLocked) ? "Move to private space" : "Remove from private space",
                    systemImage: !note.isLocked ? "lock.fill" : "lock.slash.fill"
                )
            }
        }
    }
    
    /// Button for saving the current note by adding it to the ViewModel's notes array.
    var saveNoteButtonView: some View {
        Button("Save") {
            viewModel.add(note: note)
            dismiss()
            
            HapticManager.instance.notification(type: .success)
        }
    }
}
