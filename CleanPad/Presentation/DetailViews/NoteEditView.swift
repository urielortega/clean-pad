//
//  NoteEditView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/09/23.
//

import SwiftUI

struct NoteEditView: View {
    @State var note: Note
    
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    var creatingNewNote: Bool // Property to show Cancel and Save buttons, and handle onChange closures.
    @FocusState private var textEditorIsFocused: Bool // Property to show the OK button that dismisses keyboard.
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
                        Menu {
                            isLockedToggleButtonView
                        } label: {
                            Label("More options", systemImage: "ellipsis.circle")
                        }
                        
                        if textEditorIsFocused {
                            Button("OK") { textEditorIsFocused = false }
                        } else if (creatingNewNote && !textEditorIsFocused) {
                            saveNoteButtonView
                        }
                    }
                }
            }
        }
    }
    
    var titleTextFieldView: some View {
        TextField(note.title, text: $note.title, prompt: Text("Title it"))
            .font(.title).bold()
            .padding()
            .onChange(of: note.title) { _ in
                // When changing an existing note, save it while typing using update().
                if !creatingNewNote {
                    viewModel.update(note: note)
                }
            }
    }
    
    var textContentTextEditorView: some View {
        TextEditor(text: $note.textContent)
            .ignoresSafeArea()
            .padding(.horizontal)
            .focused($textEditorIsFocused)
            .onChange(of: note.textContent) { _ in
                // When changing an existing note, save it while typing using update().
                if !creatingNewNote {
                    viewModel.update(note: note)
                }
            }
    }
    
    var isLockedToggleButtonView: some View {
        Button {
            note.isLocked.toggle() // To properly update the UI.
            viewModel.updateLockStatus(for: note)
        } label: {
            Label(
                !note.isLocked ? "Move to personal space" : "Remove from personal space",
                systemImage: !note.isLocked ? "lock.fill" : "lock.slash.fill"
            )
        }
    }
    
    var saveNoteButtonView: some View {
        Button("Save") {
            viewModel.add(note: note)
            viewModel.saveAllNotes()
            dismiss()
            successHapticFeedback()
        }
    }
    
    func successHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
