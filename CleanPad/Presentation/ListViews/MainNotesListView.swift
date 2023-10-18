//
//  MainNotesListView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 20/09/23.
//

import SwiftUI

/// Main View that shows the list of non-locked notes, as well as buttons to access locked (personal) notes and create new notes.
struct MainNotesListView: View {
    // Using the viewModel created in ContentView with @ObservedObject.
    @ObservedObject var viewModel: NotesListViewModel
    @Binding var showEditViewSheet: Bool
    
    var body: some View {
        ZStack {
            if viewModel.selectedTab == .nonLockedNotes {
                NonLockedNotesListView(viewModel: viewModel, showEditViewSheet: $showEditViewSheet)
            } else {
                LockedNotesListView(viewModel: viewModel, showEditViewSheet: $showEditViewSheet)
            }
            
            CustomTabBar(viewModel: viewModel)
        }
    }
}

struct CustomTabBar: View {
    @ObservedObject var viewModel: NotesListViewModel

    var body: some View {
        VStack {
            Spacer() // To push the TabBar to the bottom.
            
            HStack {
                Spacer()
                
                Button {
                    // TODO: Show non-locked notes list.
                    viewModel.selectedTab = .nonLockedNotes
                } label: {
                    VStack {
                        Label("Notes", systemImage: "note.text")
                            .padding(.bottom, 4)
                    }
                }
                .padding(.horizontal, 10)

                Spacer()
                CustomHStackDivider()
                Spacer()
                
                Button {
                    // TODO: Show locked notes list.
                    viewModel.selectedTab = .lockedNotes
                } label: {
                    VStack {
                        Label("Personal", systemImage: "lock.fill")
                            .padding(.bottom, 4)
                    }
                }
                .padding(.trailing, 10)
                
                Spacer()
            }
            .dockStyle()
        }
    }
}
