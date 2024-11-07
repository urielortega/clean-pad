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
    
    /// Property to show WhatsNewView when updating app.
    @AppStorage("isAppJustUpdated") var isAppJustUpdated: Bool = true
    
    /// Property to modify access to locked notes when phase changes.
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            MainScreenView(
                viewModel: viewModel,
                dateViewModel: dateViewModel,
                sheetsViewModel: sheetsViewModel,
                showNoteEditViewSheet: $sheetsViewModel.showNoteEditViewSheet,
                showCategoriesSheet: $sheetsViewModel.showCategorySelectionSheet
            )
            .navigationTitle(viewModel.isNonLockedNotesTabSelected ? "Notes" : "Private Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isNonLockedNotesTabSelected { // Non-Locked Notes Tab is selected.
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
                isAppJustUpdated = false // Setting the flag to false so WhatsNewView won't show.
            } else if isAppJustUpdated {
                sheetsViewModel.showWhatsNewSheet = true
                isAppJustUpdated = false // Setting the flag to false so WhatsNewView won't show again.
            }
        }
        .sheet(isPresented: $sheetsViewModel.showWelcomeSheet) { WelcomeView() }
        .sheet(isPresented: $sheetsViewModel.showWhatsNewSheet) { WhatsNewView() }
        .sheet(isPresented: $sheetsViewModel.showFeedbackSheet) { FeedbackView() }
        .sheet(isPresented: $sheetsViewModel.showAboutSheet) { AboutCleanPadView() }
        .onChange(of: scenePhase) { phase, _ in
            // Restrict access to locked notes when the app enters the background.
            if phase == ScenePhase.background {
                viewModel.isUnlocked = false
            }
        }
    }
}

// MARK: - Extension to group secondary views in ContentView.
extension ContentView {
    /// Button for hiding locked notes list.
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
    
    /// Button for switching between Grid and List view.
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
    
    /// Button for showing View for providing feedback.
    var showFeedbackViewButtonView: some View {
        Button {
            sheetsViewModel.showFeedbackSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label("Feedback", systemImage: "ellipsis.message")
        }
    }
    
    /// Button for showing View for providing feedback.
    var showAboutViewButtonView: some View {
        Button {
            sheetsViewModel.showAboutSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label("About CleanPad", systemImage: "book.pages")
        }
    }

}

#Preview("ContentView") {
    ContentView()
}
