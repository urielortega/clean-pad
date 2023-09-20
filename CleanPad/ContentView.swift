//
//  ContentView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import SwiftUI

struct ContentView: View {
    // Creating shared viewModel with @StateObject.
    @StateObject var viewModel = NotesListViewModel()
    
    @State private var showEditViewSheet = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                Group {
                    if viewModel.notes.isEmpty {
                        EmptyListView(
                            viewModel: viewModel,
                            showEditViewSheet: $showEditViewSheet
                        )
                    } else {
                        AllNotesListView(viewModel: viewModel)
                    }
                }
                .navigationTitle("Your Space")
                .toolbar {
                    ToolbarItem {
                        Button {
                            showEditViewSheet.toggle()
                        } label: {
                            Label("Create note", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showEditViewSheet) {
                    // NoteEditView with a blank Note:
                    NoteEditView(note: Note(), creatingNewNote: true)
                }
            }
            
            BackgroundView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Child Views.
struct EmptyListView: View {
    // Using the viewModel in a different view with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @Binding var showEditViewSheet: Bool
    
    var body: some View {
        Button {
            showEditViewSheet.toggle()
        } label: {
            HStack {
                Text(viewModel.placeholders.randomElement() ?? "Start writing...")
                    .font(.system(size: 60))
                    .fontWeight(.black)
                    .fontDesign(.serif).italic()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
            }
            .padding()
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        Color.brown
            .opacity(0.15)
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

struct AllNotesListView: View {
    // Using the viewModel in a different view with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        Form {
            Section {
                NavigationLink {
                    // Opens another List, only for locked notes.
                    LockedNotesListView(viewModel: viewModel)
                } label: {
                    Label("Personal notes", systemImage: "lock.fill")
                        .foregroundColor(.brown)
                }
            }
            
            // For non-locked notes:
            NonLockedNotesListView(viewModel: viewModel)
        }
    }
}

struct LockedNotesListView: View {
    @ObservedObject var viewModel: NotesListViewModel

    var body: some View {
        List {
            ForEach(viewModel.notes.filter { $0.isLocked }) { note in
                NavigationLink {
                    // Open NoteEditView with the tapped note.
                    NoteEditView(note: note, creatingNewNote: false)
                } label: {
                    VStack(alignment: .leading) {
                        Text(note.title)
                        Text(note.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            // TODO: .onDelete()
        }
        .navigationTitle("Personal")
    }
}

struct NonLockedNotesListView: View {
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.notes.filter { $0.isLocked == false }) { note in
                NavigationLink {
                    // Open NoteEditView with the tapped note.
                    NoteEditView(note: note, creatingNewNote: false)
                } label: {
                    VStack(alignment: .leading) {
                        Text(note.title)
                        Text(note.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            // TODO: .onDelete()
        }
    }
}

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
