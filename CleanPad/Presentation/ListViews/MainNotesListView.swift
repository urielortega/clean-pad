//
//  MainNotesListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

struct MainNotesListView: View {
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @Binding var showEditViewSheet: Bool

    var body: some View {
        Form {
            // Locked notes section.
            Section {
                NavigationLink {
                    LockedNotesListView(viewModel: viewModel)
                } label: {
                    Label("Personal notes", systemImage: "lock.fill")
                        .foregroundColor(.brown)
                }
            }
            
            // Non-locked notes section.
            Section {
                if viewModel.notes.filter({ $0.isLocked == false }).isEmpty {
                    EmptyListView(
                        viewModel: viewModel,
                        showEditViewSheet: $showEditViewSheet
                    )
                } else {
                    NonLockedNotesListView(viewModel: viewModel)
                }
            }
        }
    }
}
