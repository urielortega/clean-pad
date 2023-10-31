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
                NonLockedNotesView(
                    viewModel: viewModel,
                    showEditViewSheet: $showEditViewSheet
                )
            } else {
                LockedNotesListView(
                    viewModel: viewModel,
                    showEditViewSheet: $showEditViewSheet
                )
            }
            
            // Hide the CustomTabBar when the system keyboard is shown.
            if !viewModel.isKeyboardPresented {
                CustomTabBar(viewModel: viewModel)
            }
        }
        .onReceive(keyboardPublisher) { value in
            withAnimation {
                viewModel.isKeyboardPresented = value
            }
        }
    }
}

/// Tab Bar with two buttons to switch between non-locked notes list and locked notes list.
struct CustomTabBar: View {
    @ObservedObject var viewModel: NotesListViewModel

    var body: some View {
        VStack {
            Spacer() // To push the TabBar to the bottom.
            
            HStack {
                Spacer()
                Button {
                    withAnimation(.bouncy) { viewModel.selectedTab = .nonLockedNotes }
                    HapticManager.instance.impact(style: .soft)
                } label: {
                    nonLockedNotesTabLabel
                }
                .padding(.horizontal, 10)
                
                CustomHStackDivider()
                    .padding(.vertical)
                
                Button {
                    withAnimation(.bouncy) { viewModel.selectedTab = .lockedNotes }
                    HapticManager.instance.impact(style: .soft)
                } label: {
                    lockedNotesTabLabel
                }
                .padding(.trailing, 10)
                Spacer()
            }
            .frame(height: 50)
            .dockStyle()
        }
    }
    
    var nonLockedNotesTabLabel: some View {
        HStack {
            Spacer()
            Label("Notes", systemImage: "note.text")
                .padding(.bottom, 4)
                .tint(viewModel.isNonLockedNotesTabSelected ? .brown : .gray)
                .bold(viewModel.isNonLockedNotesTabSelected ? true : false)
                .scaleEffect(viewModel.isNonLockedNotesTabSelected ? 1.0 : 0.95)
            Spacer()
        }
    }
    
    var lockedNotesTabLabel: some View {
        HStack {
            Spacer()
            Label(
                "Personal",
                systemImage: viewModel.isUnlocked ? "lock.open.fill" : "lock.fill"
            )
            .padding(.bottom, 4)
            .tint(viewModel.isLockedNotesTabSelected ? .brown : .gray)
            .bold(viewModel.isLockedNotesTabSelected ? true : false)
            .scaleEffect(viewModel.isLockedNotesTabSelected ? 1.0 : 0.9)
            Spacer()
        }
    }
}
