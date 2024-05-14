//
//  ContentView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import SwiftUI

struct ContentView: View {
    // Creating shared ViewModels with @StateObject.
    @StateObject var viewModel = NotesListViewModel()
    @StateObject var dateViewModel = DateViewModel()
    @StateObject var sheetsViewModel = SheetsViewModel()
    
    /// Property to show WelcomeView when launching app for the first time.
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    /// Property to modify access to locked notes when phase changes.
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            MainScreenView(
                viewModel: viewModel,
                dateViewModel: dateViewModel,
                showEditViewSheet: $sheetsViewModel.showEditViewSheet,
                showCategoriesSheet: $sheetsViewModel.showCategorySelectionSheet
            )
            .navigationTitle(viewModel.isNonLockedNotesTabSelected ? "Notes" : "Private Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isNonLockedNotesTabSelected {
                        lockAndUnlockNotesButtonView
                    } else { // Locked Notes Tab is selected.
                        if viewModel.isUnlocked {
                            lockNotesButtonView
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    if viewModel.isNonLockedNotesTabSelected || (viewModel.isLockedNotesTabSelected && viewModel.isUnlocked) {
                        Menu {
                            if viewModel.idiom == .pad {
                                showAboutViewButtonView
                                showFeedbackViewButtonView
                            } else {
                                switchViewsButtonView
                                Divider()
                                showAboutViewButtonView
                                showFeedbackViewButtonView
                            }
                        } label: {
                            Label("More options", systemImage: "ellipsis.circle")
                        }
                    }
                }
            }
        }
        .onAppear {
            if isFirstLaunch {
                sheetsViewModel.showWelcomeSheet = true
                isFirstLaunch = false // Setting the flag to false so WelcomeView won't show again.
            }
        }
        .sheet(isPresented: $sheetsViewModel.showWelcomeSheet) { WelcomeView() }
        .sheet(isPresented: $sheetsViewModel.showEditViewSheet) {
            if viewModel.isNonLockedNotesTabSelected {
                // Open NoteEditView with a blank Note:
                NoteEditView(note: Note(), viewModel: viewModel, creatingNewNote: true)
            } else { // Locked Notes Tab is selected.
                // Open NoteEditView with a blank locked Note:
                NoteEditView(note: Note(isLocked: true), viewModel: viewModel, creatingNewNote: true)
            }
        }
        .sheet(isPresented: $sheetsViewModel.showFeedbackSheet) { FeedbackView() }
        .sheet(isPresented: $sheetsViewModel.showAboutSheet) { AboutCleanPadView() }
        .sheet(isPresented: $sheetsViewModel.showCategorySelectionSheet) {
            CategorySelectionView(viewModel: viewModel, sheetsViewModel: sheetsViewModel)
        }
        .alert("Authentication error", isPresented: $viewModel.isShowingAuthenticationError) {
            Button("OK") { }
        } message: {
            Text(viewModel.authenticationError)
        }
        .onChange(of: scenePhase) { phase, _ in
            if phase == ScenePhase.background {
                viewModel.isUnlocked = false
            }
        }
    }
    
    /// Button to hide locked notes list.
    var lockNotesButtonView: some View {
        Button {
            withAnimation(.bouncy) {
                viewModel.lockNotes()
                HapticManager.instance.impact(style: .rigid)
            }
        } label: {
            Label("Lock notes", systemImage: "lock.open.fill")
        }
        .accessibilityLabel("Lock access to private notes")
    }
    
    /// Button to allow and forbid access to the locked notes list (private space).
    var lockAndUnlockNotesButtonView: some View {
        Button {
            withAnimation(.bouncy) {
                if viewModel.isUnlocked {
                    viewModel.lockNotes()
                    HapticManager.instance.impact(style: .rigid)
                } else {
                    viewModel.authenticate(for: .viewNotes) { }
                }
            }
        } label: {
            Image(systemName: viewModel.isUnlocked ? "lock.open.fill" : "lock.fill")
                .contentTransition(.symbolEffect(.replace))
        }
        .accessibilityLabel(
            viewModel.isUnlocked ? "Your private notes are currently accessible" : "Your private notes are currently locked"
        )
        .accessibilityHint(viewModel.isUnlocked ? "Tap to lock access" : "Tap to unlock access")
        .accessibilityAddTraits(.isButton)
    }
    
    /// Button to switch between Grid and List view.
    var switchViewsButtonView: some View {
        Button {
            withAnimation { viewModel.isGridViewSelected.toggle() }
        } label: {
            Label(
                viewModel.isGridViewSelected ? "View as List" : "View as Grid",
                systemImage: viewModel.isGridViewSelected ? "list.bullet" : "rectangle.grid.2x2"
            )
        }
    }
    
    /// Button to show view for providing feedback.
    var showFeedbackViewButtonView: some View {
        Button {
            sheetsViewModel.showFeedbackSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label("Feedback", systemImage: "ellipsis.message")
        }
    }
    
    /// Button to show view for providing feedback.
    var showAboutViewButtonView: some View {
        Button {
            sheetsViewModel.showAboutSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label("About CleanPad", systemImage: "book.pages")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
