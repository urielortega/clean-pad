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
    @ObservedObject var vm: NotesListViewModel
    
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
                        if textEditorIsFocused {
                            Button("OK") { textEditorIsFocused = false }
                        } else if !textEditorIsFocused {
                            Menu {
                                isLockedToggleButtonView
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
        TextField(note.title, text: $note.title, prompt: Text("Title it"))
            .font(.title).bold()
            .padding()
            .onChange(of: note.title) { _ in
                // When changing an existing note, save it while typing using update().
                if !creatingNewNote {
                    vm.update(note: note)
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
                    vm.update(note: note)
                }
            }
    }
    
    var isLockedToggleButtonView: some View {
        Button {
            if creatingNewNote {
                note.isLocked.toggle()
            } else {
                vm.updateLockStatus(for: note)
            }
        } label: {
            if creatingNewNote {
                Label(
                    !note.isLocked ? "Move to personal space" : "Remove from personal space",
                    systemImage: !note.isLocked ? "lock.fill" : "lock.slash.fill"
                )
            } else {
                Label(
                    !(vm.getNoteFromNotesArray(note: note)!.isLocked) ? "Move to personal space" : "Remove from personal space",
                    systemImage: !note.isLocked ? "lock.fill" : "lock.slash.fill"
                )
            }
        }
    }
    
    var saveNoteButtonView: some View {
        Button("Save") {
            vm.add(note: note)
            vm.saveAllNotes()
            dismiss()
            successHapticFeedback()
        }
    }
    
    func successHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
