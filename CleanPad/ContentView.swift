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
                        lockAndUnlockNotesButtonView
                        CreateNoteButtonView(showEditViewSheet: $showEditViewSheet)
                    }
                }
                .sheet(isPresented: $showEditViewSheet) {
                    // NoteEditView with a blank Note:
                    NoteEditView(note: Note(), viewModel: viewModel, creatingNewNote: true)
                }
            }
            
            BackgroundColorView()
        }
        .alert("Authentication error", isPresented: $viewModel.isShowingAuthenticationError) {
            Button("OK") { }
        } message: {
            Text(viewModel.authenticationError)
        }
    }
    
    var lockAndUnlockNotesButtonView: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
