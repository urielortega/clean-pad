//
//  NoteEditView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/09/23.
//

import SwiftUI

/// View that shows a note content allowing the user to modify it, update it, save it and lock the note itself.
struct NoteEditView: View {
    @State var note: Note
    
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    /// Property to show Cancel and Save buttons, and handle `onChange` closures.
    var creatingNewNote: Bool
    
    /// Enum for controlling the focus state when creating or editing a note.
    enum FocusField: Hashable {
        case titleTextField
        case textEditorField
    }
    
    /// Property that stores the focus of the current text field.
    @FocusState private var focusedField: FocusField?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                titleTextFieldView
                Divider()
                textContentTextEditorView
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if creatingNewNote {
                        Button("Cancel") { dismiss() }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
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
        }
    }
    
    var titleTextFieldView: some View {
        TextField(note.noteTitle, text: $note.noteTitle, prompt: Text("Give it a title..."))
            .font(.title).bold()
            .padding()
            .onChange(of: note.noteTitle) { _ in
                // When changing an existing note, save it while typing using update().
                if !creatingNewNote {
                    viewModel.update(note: note)
                }
            }
            .focused($focusedField, equals: .titleTextField)
            .onAppear {
                if creatingNewNote {
                    self.focusedField = .titleTextField
                }
            }
            .onSubmit { focusedField = .textEditorField }
    }
    
    var textContentTextEditorView: some View {
        TextEditor(text: $note.noteContent)
            .padding(.horizontal)
            .focused($focusedField, equals: .textEditorField)
            .onChange(of: note.noteContent) { _ in
                // When changing an existing note, save it while typing using update().
                if !creatingNewNote {
                    viewModel.update(note: note)
                }
            }
    }
    
    /// Button to toggle `isLocked` property of a note, i.e., move it to or remove it from the personal space.
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
                    !note.isLocked ? "Move to personal space" : "Remove from personal space",
                    systemImage: !note.isLocked ? "lock.fill" : "lock.slash.fill"
                )
            } else {
                Label( // When editing an existing note, Label responds to the value of notes array (persistent storage).
                    !(viewModel.getNoteFromNotesArray(note: note)!.isLocked) ? "Move to personal space" : "Remove from personal space",
                    systemImage: !note.isLocked ? "lock.fill" : "lock.slash.fill"
                )
            }
        }
    }
    
    var saveNoteButtonView: some View {
        Button("Save") {
            viewModel.add(note: note)
            viewModel.saveAllNotes()
            dismiss()
            
            HapticManager.instance.notification(type: .success)
        }
    }
}
