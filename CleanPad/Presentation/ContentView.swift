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
            
            MainBackgroundView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
