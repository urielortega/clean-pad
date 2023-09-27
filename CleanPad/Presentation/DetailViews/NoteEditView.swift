//
//  NoteEditView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 19/09/23.
//

import SwiftUI

struct NoteEditView: View {
    @State var note: Note
    // var save: (Note) -> ()
    
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    var creatingNewNote: Bool // Property to show Cancel and Save buttons, and handle onChange closures.
    @FocusState private var textEditorIsFocused: Bool // Property to show the OK button that dismisses keyboard.
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField(note.title, text: $note.title, prompt: Text("Title it"))
                    .font(.title).bold()
                    .padding()
                    .onChange(of: note.title) { _ in
                        if !creatingNewNote {
                            viewModel.update(note: note)
                        }
                    }
                
                Divider()
                
                TextEditor(text: $note.textContent)
                    .ignoresSafeArea()
                    .padding(.horizontal)
                    .focused($textEditorIsFocused)
                    .onChange(of: note.textContent) { _ in
                        if !creatingNewNote {
                            viewModel.update(note: note)
                        }
                    }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if creatingNewNote {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Menu {
                            Button {
                                note.isLocked.toggle() // To properly update the UI.
                                
                                viewModel.updateLockStatus(for: note)
                            } label: {
                                Label(
                                    !note.isLocked ? "Move to personal folder" : "Remove from personal folder",
                                    systemImage: !note.isLocked ? "lock.fill" : "lock.slash.fill"
                                )
                            }
                        } label: {
                            Label("More options", systemImage: "ellipsis.circle")
                        }
                        
                        if textEditorIsFocused {
                            Button("OK") {
                                textEditorIsFocused = false
                            }
                        } else if (creatingNewNote && !textEditorIsFocused) {
                            Button("Save") {
                                viewModel.add(note: note)
                                viewModel.saveAllNotes()
                                
                                dismiss()
                                
                                successHapticFeedback()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func successHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
