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
    @State private var isAnimating = false
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @State private var showWelcomeSheet = false
    
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
                        if !(viewModel.notes.filter({ $0.isLocked == false }).isEmpty) {
                            CreateNoteButtonView(showEditViewSheet: $showEditViewSheet) // Only shown when the list isn't empty.
                        }
                    }
                }
            }
            
            BackgroundColorView()
        }
        .onAppear {
            if isFirstLaunch {
                showWelcomeSheet = true
                isFirstLaunch = false // Setting the flag to false so WelcomeView won't show again.
            }
        }
        .sheet(isPresented: $showWelcomeSheet) { WelcomeView() }
        .sheet(isPresented: $showEditViewSheet) {
            // NoteEditView with a blank Note:
            NoteEditView(note: Note(), viewModel: viewModel, creatingNewNote: true)
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
            isAnimating.toggle()
        } label: {
            Label(
                viewModel.isUnlocked ? "Lock notes" : "Unlock notes",
                systemImage: viewModel.isUnlocked ? "lock.open.fill" : "lock.fill"
            )
            .scaleEffect(isAnimating ? 0.7 : 1.0)
            .opacity(isAnimating ? 0.5 : 1.0)
            .animation(
                .snappy.repeatCount(1, autoreverses: true),
                value: isAnimating
            )
            .onChange(of: viewModel.isUnlocked) { _ in
                // Reset the animation when isUnlocked changes.
                isAnimating = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
