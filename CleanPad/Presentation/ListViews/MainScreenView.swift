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
    @Binding var showCategoriesSheet: Bool
    
    var body: some View {
        ZStack {
            AllNotesView(
                viewModel: viewModel,
                dateViewModel: dateViewModel,
                showEditViewSheet: $showEditViewSheet
            )
            
            CustomTabBar(
                viewModel: viewModel, 
                showEditViewSheet: $showEditViewSheet,
                showCategoriesSheet: $showCategoriesSheet
            )
        }
    }
}

/// Tab Bar with two buttons to switch between non-locked notes list and locked notes list.
struct CustomTabBar: View {
    @ObservedObject var viewModel: NotesListViewModel
    @Binding var showEditViewSheet: Bool
    @Binding var showCategoriesSheet: Bool
    
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        VStack {
            Spacer() // To push the TabBar to the bottom.
            
            HStack {
                if viewModel.showingTabButtons {
                    showCategoriesTabButton
                }
                
                tabBar
                
                if viewModel.showingTabButtons {
                    createNoteTabButton
                }
            }
            .padding(
                .horizontal, 
                (viewModel.idiom == .pad && sizeClass == .regular) ? 20 : 0
            )
        }
    }
    
    var tabBar: some View {
        HStack {
            Spacer()
            
            nonLockedNotesTabButton
            
            CustomHStackDivider()
                .padding(.vertical)
            
            lockedNotesTabButton
            
            Spacer()
        }
        .frame(height: 55)
        .dockStyle(viewModel: viewModel)
        .padding(.horizontal, viewModel.showingTabButtons ? 0 : 10)
        .padding(
            .horizontal,
            (viewModel.idiom == .pad && sizeClass == .regular) ? 10 : 0
        )
    }
    
    var nonLockedNotesTabButton: some View {
        Button {
            // Glow CustomTabBar when tapping nonLockedNotesTabButton and Non-Locked Notes Tab is selected:
            if viewModel.isNonLockedNotesTabSelected {
                withAnimation(.easeInOut(duration: 1)) {
                    viewModel.isCustomTabBarGlowing.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 1)) {
                        viewModel.isCustomTabBarGlowing.toggle()
                    }
                }
            }
            
            withAnimation(.bouncy(extraBounce: 0.2)) { viewModel.selectedTab = .nonLockedNotes }
            HapticManager.instance.impact(style: .soft)
        } label: {
            nonLockedNotesTabLabel
        }
        .padding(.horizontal, 10)
    }
    
    var lockedNotesTabButton: some View {
        Button {
            // Glow CustomTabBar when tapping lockedNotesTabButton and Locked Notes Tab is selected:
            if viewModel.isLockedNotesTabSelected {
                withAnimation(.easeInOut(duration: 1)) {
                    viewModel.isCustomTabBarGlowing.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 1)) {
                        viewModel.isCustomTabBarGlowing.toggle()
                    }
                }
            }
            
            withAnimation(.bouncy(extraBounce: 0.2)) { viewModel.selectedTab = .lockedNotes }
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
                .labelStyle(.titleOnly)
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
            .labelStyle(.titleOnly)
            .padding(.bottom, 4)
            .tint(viewModel.isLockedNotesTabSelected ? .accentColor : .gray)
            .bold(viewModel.isLockedNotesTabSelected ? true : false)
            .scaleEffect(viewModel.isLockedNotesTabSelected ? 1.0 : 0.9)
            
            Spacer()
        }
        .frame(height: 50)
        .accessibilityLabel("Your private notes.")
    }
    
    /// Button View to create a new note from the Tab Bar.
    var createNoteTabButton: some View {
        Button {
            showEditViewSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label("New note", systemImage: "plus")
                .labelStyle(.iconOnly)
                .frame(width: 55, height: 55) // Frame on Label so tap is better detected.
        }
        .dockButtonStyle(position: .right)
    }
    
    /// Button View to show all user categories from the Tab Bar.
    var showCategoriesTabButton: some View {
        Button {
            showCategoriesSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label("Select a Category", systemImage: "line.3.horizontal.decrease.circle")
                .labelStyle(.iconOnly)
                .frame(width: 55, height: 55) // Frame on Label so Menu Tap is better detected.
                .imageScale(.large)
                .tint(viewModel.selectedCategory.color.gradient)
        }
        .dockButtonStyle(position: .left)
    }
}

#Preview("CustomTabBar") {
    CustomTabBar(viewModel: NotesListViewModel(), showEditViewSheet: .constant(false), showCategoriesSheet: .constant(false))
}
