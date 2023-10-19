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
    var isNonLockedNotesTabSelected: Bool { viewModel.selectedTab == .nonLockedNotes }
    var isLockedNotesTabSelected: Bool { viewModel.selectedTab == .lockedNotes }

    var body: some View {
        VStack {
            Spacer() // To push the TabBar to the bottom.
            
            HStack {
                Spacer()
                
                Button {
                    withAnimation { viewModel.selectedTab = .nonLockedNotes }
                } label: {
                    nonLockedNotesTabLabel
                }
                .padding(.horizontal, 10)

                CustomHStackDivider()
                
                Button {
                    withAnimation { viewModel.selectedTab = .lockedNotes }
                } label: {
                    lockedNotesTabLabel
                }
                .padding(.trailing, 10)
                
                Spacer()
            }
            .dockStyle()
        }
    }
    
    var nonLockedNotesTabLabel: some View {
        HStack {
            Spacer()
            Label("Notes", systemImage: "note.text")
                .padding(.bottom, 4)
                .tint(isNonLockedNotesTabSelected ? .brown : .gray)
                .bold(isNonLockedNotesTabSelected ? true : false)
                .scaleEffect(isNonLockedNotesTabSelected ? 1.0 : 0.9)
            Spacer()
        }
    }
    
    var lockedNotesTabLabel: some View {
        HStack {
            Spacer()
            Label("Personal", systemImage: "lock.fill")
                .padding(.bottom, 4)
                .tint(isLockedNotesTabSelected ? .brown : .gray)
                .bold(isLockedNotesTabSelected ? true : false)
                .scaleEffect(isLockedNotesTabSelected ? 1.0 : 0.9)
            Spacer()
        }
    }
}
