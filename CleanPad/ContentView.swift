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
    
    /// Property to show WelcomeView when launching app for the first time.
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    @State private var showWelcomeSheet = false
    @State private var showEditViewSheet = false
    @State private var showFeedbackSheet = false
    @State private var showAboutSheet = false
    @State private var showCategorySelectionSheet = false
    @State private var showEditableCategoriesSheet = false
    
    var body: some View {
        NavigationStack {
            MainScreenView(
                viewModel: viewModel,
                dateViewModel: dateViewModel,
                showEditViewSheet: $showEditViewSheet,
                showCategoriesSheet: $showCategorySelectionSheet
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
                showWelcomeSheet = true
                isFirstLaunch = false // Setting the flag to false so WelcomeView won't show again.
            }
        }
        .sheet(isPresented: $showWelcomeSheet) { WelcomeView() }
        .sheet(isPresented: $showEditViewSheet) {
            if viewModel.isNonLockedNotesTabSelected {
                // Open NoteEditView with a blank Note:
                NoteEditView(note: Note(), viewModel: viewModel, creatingNewNote: true)
            } else { // Locked Notes Tab is selected.
                // Open NoteEditView with a blank locked Note:
                NoteEditView(note: Note(isLocked: true), viewModel: viewModel, creatingNewNote: true)
            }
        }
        .sheet(isPresented: $showFeedbackSheet) { FeedbackView() }
        .sheet(isPresented: $showAboutSheet) { AboutCleanPadView() }
        .sheet(isPresented: $showCategorySelectionSheet) {
            CategorySelectionView(
                viewModel: viewModel, 
                showEditableCategoriesSheet: $showEditableCategoriesSheet
            )
        }
        .alert("Authentication error", isPresented: $viewModel.isShowingAuthenticationError) {
            Button("OK") { }
        } message: {
            Text(viewModel.authenticationError)
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
            showFeedbackSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label("Feedback", systemImage: "ellipsis.message")
        }
    }
    
    /// Button to show view for providing feedback.
    var showAboutViewButtonView: some View {
        Button {
            showAboutSheet.toggle()
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
