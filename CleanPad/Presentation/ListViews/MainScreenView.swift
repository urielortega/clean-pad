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
    
    @Binding var showEditViewSheet: Bool
    
    var body: some View {
        ZStack {
            AllNotesView(
                viewModel: viewModel,
                dateViewModel: dateViewModel,
                showEditViewSheet: $showEditViewSheet
            )
            
            CustomTabBar(viewModel: viewModel)
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
                manageCategoriesTabButton
                
                HStack {
                    Spacer()
                    
                    nonLockedNotesTabButton
                    
                    CustomHStackDivider()
                        .padding(.vertical)
                    
                    lockedNotesTabButton
                    
                    Spacer()
                }
                .frame(height: 55)
                .dockStyle()
                
                createNoteTabButton
            }
        }
    }
    
    var nonLockedNotesTabButton: some View {
        Button {
            withAnimation(.bouncy) { viewModel.selectedTab = .nonLockedNotes }
            HapticManager.instance.impact(style: .soft)
        } label: {
            nonLockedNotesTabLabel
        }
        .padding(.horizontal, 10)
    }
    
    var lockedNotesTabButton: some View {
        Button {
            withAnimation(.bouncy) { viewModel.selectedTab = .lockedNotes }
            HapticManager.instance.impact(style: .soft)
        } label: {
            lockedNotesTabLabel
        }
        .padding(.trailing, 10)
    }
    
    var nonLockedNotesTabLabel: some View {
        HStack {
            Spacer()
            Label("Notes", systemImage: "note.text")
                .font(.subheadline)
                .padding(.bottom, 4)
                .tint(viewModel.isNonLockedNotesTabSelected ? .accentColor : .gray)
                .bold(viewModel.isNonLockedNotesTabSelected ? true : false)
                .scaleEffect(viewModel.isNonLockedNotesTabSelected ? 1.0 : 0.9)
            Spacer()
        }
        .frame(height: 50)
        .accessibilityLabel("Your notes.")
    }
    
    var lockedNotesTabLabel: some View {
        HStack {
            Spacer()
            Label(
                "Private",
                systemImage: viewModel.isUnlocked ? "lock.open.fill" : "lock.fill"
            )
            .font(.subheadline)
            .padding(.bottom, 4)
            .tint(viewModel.isLockedNotesTabSelected ? .accentColor : .gray)
            .bold(viewModel.isLockedNotesTabSelected ? true : false)
            .scaleEffect(viewModel.isLockedNotesTabSelected ? 1.0 : 0.9)
            Spacer()
        }
        .frame(height: 50)
        .accessibilityLabel("Your private notes.")
    }
    
    var createNoteTabButton: some View {
        Button {
            // TODO: Toggle showEditViewSheet.
        } label: {
            Label("New note", systemImage: "plus")
                .labelStyle(.iconOnly)
        }
        .frame(height: 55)
        .dockButtonStyle(position: .right)
    }
    
    var manageCategoriesTabButton: some View {
        Button {
            // TODO: Open menu to manage categories.
        } label: {
            Label("Categories", systemImage: "tag.fill")
                .labelStyle(.iconOnly)
        }
        .frame(height: 55)
        .dockButtonStyle(position: .left)
    }
}

#Preview("CustomTabBar") {
    CustomTabBar(viewModel: NotesListViewModel())
}
