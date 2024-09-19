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
    /// A modifiable copy of the note used for editing.
    @State private var noteCopy: Note
    
    /// A property for storing the original note, used to detect changes.
    private let originalNote: Note

    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    /// Property to show Cancel and Save buttons, and handle `onChange` closures.
    @State var creatingNewNote: Bool
    
    /// Property to control the displaying of a note whose 'isLocked' property was recently toggled.
    @State var editingAToggledNote: Bool = false
    
    /// Property that stores the focus of the current text field.
    @FocusState private var focusedField: FocusField?
    
    @Environment(\.dismiss) var dismiss
    
    /// Property to adapt the UI for VoiceOver users.
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    /// Property to modify access to locked notes when phase changes.
    @Environment(\.scenePhase) private var scenePhase
    
    init(
        note: Note,
        viewModel: NotesListViewModel,
        sheetsViewModel: SheetsViewModel,
        creatingNewNote: Bool
    ) {
        _noteCopy = State(initialValue: note)
        self.originalNote = note

        self.viewModel = viewModel
        self.sheetsViewModel = sheetsViewModel
        self.creatingNewNote = creatingNewNote
    }
    
    var body: some View {
        NavigationStack {
            // Show UnlockNotesView only when...
            if ( // ...access is locked, the note is private, it isn't a new one and the 'isLocked' property wasn't recently toggled.
                !viewModel.isUnlocked && (noteCopy.isLocked == true) && !creatingNewNote && !editingAToggledNote
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
                VStack(spacing: .zero) {
                    titleTextFieldView
                        .padding(.vertical)
                    
                    Divider()
                    textContentTextEditorView
                    Divider()
                    Button("Change Note Category") { sheetsViewModel.showNoteCategorySheet.toggle() }
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
                                        ShareLink(item: "\(noteCopy.noteTitle)\n\(noteCopy.noteContent)")
                                        DeleteNoteButton(
                                            note: noteCopy,
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
                        note: $noteCopy,
                        creatingNewNote: $creatingNewNote,
                        viewModel: viewModel,
                        sheetsViewModel: sheetsViewModel
                    )
                }
            }
        }
        .onDisappear {
            // Only update if editing an existing note and changes were made:
            if !creatingNewNote && noteCopy != originalNote {
                viewModel.update(note: noteCopy)
            }
        }
        .onChange(of: scenePhase) { phase, _ in
            // When on background phase...
            if phase == ScenePhase.background {
                // ...toggle editingAToggledNote, so the contents of the current private note can be hidden.
                editingAToggledNote = false
            }
        }
        .presentationCornerRadius(Constants.roundedRectCornerRadius)
    }
}

// MARK: - Extension to group secondary views in NoteEditView.
extension NoteEditView {
    var titleTextFieldView: some View {
        TextField(
            noteCopy.noteTitle,
            text: $noteCopy.noteTitle,
            prompt: Text(
                Constants.untitledNotePlaceholders.randomElement() ?? "Title your note..."
            )
        )
        .font(.title2).bold()
        .padding(.leading)
        .focused($focusedField, equals: .titleTextField)
        .onAppear {
            if creatingNewNote { focusedField = .titleTextField }
        }
        .onSubmit { focusedField = .textEditorField }
        .submitLabel(.next)
    }
    
    var textContentTextEditorView: some View {
        TextEditor(text: $noteCopy.noteContent)
            .padding(.horizontal)
            .focused($focusedField, equals: .textEditorField)
    }
    
    /// Button to toggle `isLocked` property of a note, i.e., move it to or remove it from the private space.
    var isLockedToggleButtonView: some View {
        Button {
            viewModel.authenticate(for: .changeLockStatus) {
                noteCopy.isLocked.toggle()
                editingAToggledNote = true // 'isLocked' property was recently toggled.
            }
        } label: {
            Label(
                !noteCopy.isLocked ? "Move to private space" : "Remove from private space",
                systemImage: !noteCopy.isLocked ? "lock.fill" : "lock.slash.fill"
            )
        }
    }
    
    /// Button for saving a new note by adding it to the ViewModel's notes array.
    var saveNoteButtonView: some View {
        Button("Save") {
            viewModel.add(note: noteCopy)
            dismiss()
            
            HapticManager.instance.notification(type: .success)
        }
    }
}
