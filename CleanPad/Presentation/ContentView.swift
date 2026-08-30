//
//  ContentView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import SwiftUI

struct ContentView: View {
    // Creating shared app state.
    @State private var notesStore = NotesStore()
    @State private var viewModel = MainScreenViewModel()
    @State private var privateNotesAccess = PrivateNotesAccessState(authenticationService: LocalAuthenticationService())
    @StateObject var dateViewModel = DateViewModel()
    @StateObject var sheetsViewModel = SheetsViewModel()
    
    /// Property to show WelcomeView when launching app for the first time.
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    /// Persisted app version that last presented the What's New screen.
    @AppStorage("lastSeenAppVersion") var lastSeenAppVersion: String = ""
    
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
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if viewModel.isNonLockedNotesTabSelected { // Non-Locked Notes Tab is selected.
                        lockAndUnlockNotesButtonView
                    } else { // Locked Notes Tab is selected.
                        if privateNotesAccess.isUnlocked {
                            lockNotesButtonView
                        }
                    }
                    
                    if viewModel.showingDockButtons(isPrivateAccessUnlocked: privateNotesAccess.isUnlocked) {
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
        .environment(notesStore)
        .environment(privateNotesAccess)
        .onAppear {
            let appVersion = currentAppVersion
            
            if isFirstLaunch {
                sheetsViewModel.showWelcomeSheet = true
                isFirstLaunch = false // Setting the flag to false so WelcomeView won't show again.
                lastSeenAppVersion = appVersion // Prevents WhatsNewView from showing right after first launch.
            } else if lastSeenAppVersion != appVersion {
                sheetsViewModel.showWhatsNewSheet = true
            }
        }
        .sheet(isPresented: $sheetsViewModel.showWelcomeSheet) { WelcomeView() }
        .sheet(
            isPresented: $sheetsViewModel.showWhatsNewSheet,
            onDismiss: markCurrentAppVersionAsSeen
        ) {
            WhatsNewView()
        }
        .sheet(isPresented: $sheetsViewModel.showFeedbackSheet) { FeedbackView() }
        .sheet(isPresented: $sheetsViewModel.showAboutSheet) { AboutCleanPadView() }
        .onChange(of: scenePhase) { _, newPhase in
            // Restrict access to locked notes when the app enters the background.
            if newPhase == ScenePhase.background {
                privateNotesAccess.lockNotes()
            }
        }
    }
}

// MARK: - Extension to group secondary views in ContentView.
extension ContentView {
    /// Current user-facing app version from the app bundle.
    private var currentAppVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// Marks the current app version as seen after the What's New screen is dismissed.
    private func markCurrentAppVersionAsSeen() {
        lastSeenAppVersion = currentAppVersion
    }
    
    /// Button for hiding locked notes list.
    var lockNotesButtonView: some View {
        Button {
            withAnimation(.bouncy) {
                privateNotesAccess.lockNotes()
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
                if privateNotesAccess.isUnlocked {
                    privateNotesAccess.lockNotes()
                    HapticManager.instance.impact(style: .rigid)
                } else {
                    privateNotesAccess.authenticate(for: .viewNotes) { }
                }
            }
        } label: {
            Image(systemName: privateNotesAccess.isUnlocked ? "lock.open.fill" : "lock.fill")
                .contentTransition(.symbolEffect(.replace))
        }
        .accessibilityLabel(
            privateNotesAccess.isUnlocked ? "Your private notes are currently accessible" : "Your private notes are currently locked"
        )
        .accessibilityHint(privateNotesAccess.isUnlocked ? "Tap to lock access" : "Tap to unlock access")
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
