//
//  MainScreenView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 03/11/23.
//

import SwiftUI

/// Main View that shows the list of notes, as well as buttons to access locked (private) notes and create new notes, and a custom tab bar.
struct MainScreenView: View {
    // Using the viewModels created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var dateViewModel: DateViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    
    @Binding var showNoteEditViewSheet: Bool
    @Binding var showCategoriesSheet: Bool
    
    var body: some View {
        ZStack {
            AllNotesView(
                viewModel: viewModel,
                dateViewModel: dateViewModel,
                showNoteEditViewSheet: $showNoteEditViewSheet
            )
            
            CustomTabBar(
                viewModel: viewModel, 
                sheetsViewModel: sheetsViewModel,
                showNoteEditViewSheet: $showNoteEditViewSheet,
                showCategoriesSheet: $showCategoriesSheet
            )
        }
    }
}