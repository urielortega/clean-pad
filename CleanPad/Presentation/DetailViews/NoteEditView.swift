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
    
    var creatingNewNote: Bool // Property to show Cancel and Save buttons.
    @FocusState private var textEditorIsFocused: Bool // Property to show the OK button that dismisses keyboard.
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField(note.title, text: $note.title, prompt: Text("Title it"))
                    .font(.title).bold()
                    .padding()
                
                Divider()
                
                TextEditor(text: $note.textContent)
                    .ignoresSafeArea()
                    .padding(.horizontal)
                    .focused($textEditorIsFocused)
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
                                // TODO: Request biometrics to lock note.
                            } label: {
                                Label("Lock note", systemImage: "lock.fill")
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
                                // TODO: Save note (add() and then saveAllNotes())
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}
