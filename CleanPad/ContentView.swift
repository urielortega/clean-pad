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
                MainNotesListView(
                    viewModel: viewModel,
                    showEditViewSheet: $showEditViewSheet
                )
                .navigationTitle("Your CleanPad")
                .toolbar {
                    HStack {
                        Button {
                            if viewModel.isUnlocked {
                                viewModel.lockNotes()
                            } else {
                                viewModel.authenticate(for: .viewNotes)
                            }
                        } label: {
                            Label(
                                viewModel.isUnlocked ? "Lock notes" : "Unlock notes",
                                systemImage: viewModel.isUnlocked ? "lock.open.fill" : "lock.fill"
                            )
                        }

                        Button {
                            showEditViewSheet.toggle()
                        } label: {
                            Label("Create note", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showEditViewSheet) {
                    // NoteEditView with a blank Note:
                    NoteEditView(note: Note(), viewModel: viewModel, creatingNewNote: true)
                }
            }
            
            MainBackgroundView()
        }
        .alert("Authentication error", isPresented: $viewModel.isShowingAuthenticationError) {
            Button("OK") { }
        } message: {
            Text(viewModel.authenticationError)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
