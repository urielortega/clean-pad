//
//  MainScreenView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 03/11/23.
//

import SwiftUI

/// Main View that shows the list of notes, as well as buttons to access locked notes and the Dock.
struct MainScreenView: View {
    // Using the viewModels created in ContentView.
    @Bindable var viewModel: MainScreenViewModel
    @ObservedObject var dateViewModel: DateViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    @Binding var showNoteEditViewSheet: Bool
    @Binding var showCategoriesSheet: Bool
    
    /// State that controls private-notes access and authentication alerts.
    @Environment(PrivateNotesAccessState.self) private var privateNotesAccess
    
    var body: some View {
        @Bindable var privateNotesAccess = privateNotesAccess
        
        ZStack {
            AllNotesView(
                viewModel: viewModel,
                dateViewModel: dateViewModel,
                sheetsViewModel: sheetsViewModel,
                showNoteEditViewSheet: $showNoteEditViewSheet
            )
            
            DockView(
                viewModel: viewModel,
                sheetsViewModel: sheetsViewModel,
                showNoteEditViewSheet: $showNoteEditViewSheet,
                showCategoriesSheet: $showCategoriesSheet
            )
        }
        .alert("Authentication error", isPresented: $privateNotesAccess.isShowingAuthenticationErrorOnMainScreen) {
            Button("OK") { }
        } message: {
            Text(privateNotesAccess.authenticationError)
        }
    }
}
