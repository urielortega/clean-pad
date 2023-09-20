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
            }
            .toolbar {
                if creatingNewNote {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            // TODO: Save note (add() and then saveAllNotes())
                        }
                    }
                }
            }
        }
    }
}
