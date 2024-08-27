//
//  CustomTabBar.swift
//  CleanPad
//
//  Created by Uriel Ortega on 27/08/24.
//

import Foundation
import SwiftUI

/// Tab Bar with buttons to switch between the non-locked notes list and the locked notes list, show categories and create a new note.
struct CustomTabBar: View {
    @ObservedObject var viewModel: NotesListViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    @Binding var showNoteEditViewSheet: Bool
    @Binding var showCategoriesSheet: Bool
    
    /// Property to adapt the UI according to the available space.
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
}

// MARK: - Extension to group secondary views in CustomTabBar.
extension CustomTabBar {
    /// View that holds the nonLockedNotesTabButton and the lockedNotesTabButton with a Dock style.
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
    
    /// Button for accessing the non-locked notes list.
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
            
            withAnimation(.bouncy) { viewModel.selectedTab = .nonLockedNotes }
            HapticManager.instance.impact(style: .soft)
        } label: {
            nonLockedNotesTabLabel
        }
        .padding(.horizontal, 10)
    }
    
    /// Button for accessing the locked notes list.
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
            
            withAnimation(.bouncy) { viewModel.selectedTab = .lockedNotes }
            HapticManager.instance.impact(style: .soft)
        } label: {
            lockedNotesTabLabel
        }
        .padding(.trailing, 10)
    }
    
    /// Label for nonLockedNotesTabButton.
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
    
    /// Label for lockedNotesTabButton.
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
    
    /// Button for creating a new note from the Tab Bar.
    var createNoteTabButton: some View {
        Button {
            showNoteEditViewSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label("New note", systemImage: "plus")
                .labelStyle(.iconOnly)
                .frame(width: 55, height: 55) // Frame on Label so tap is better detected.
        }
        .dockButtonStyle(position: .right)
        .sheet(isPresented: $sheetsViewModel.showNoteEditViewSheet) {
            if viewModel.isNonLockedNotesTabSelected {
                // Open NoteEditView with a blank Note:
                NoteEditView(note: Note(), viewModel: viewModel, sheetsViewModel: sheetsViewModel, creatingNewNote: true)
            } else { // Locked Notes Tab is selected.
                // Open NoteEditView with a blank locked Note:
                NoteEditView(note: Note(isLocked: true), viewModel: viewModel, sheetsViewModel: sheetsViewModel, creatingNewNote: true)
            }
        }
    }
    
    /// Button for showing all user categories from the Tab Bar.
    var showCategoriesTabButton: some View {
        Button {
            showCategoriesSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label(
                "Select a Category",
                systemImage: viewModel.isSomeCategorySelected ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
            )
            .labelStyle(.iconOnly)
            .frame(width: 55, height: 55) // Frame on Label so Menu Tap is better detected.
            .imageScale(.large)
            .tint(viewModel.selectedCategory.color.gradient)
        }
        .dockButtonStyle(position: .left)
        .sheet(isPresented: $sheetsViewModel.showCategorySelectionSheet) {
            viewModel.isEditModeActive = false // When dismissing the sheet.
        } content: {
            CategorySelectionView(viewModel: viewModel, sheetsViewModel: sheetsViewModel)
        }
    }
}

#Preview("CustomTabBar") {
    CustomTabBar(
        viewModel: NotesListViewModel(),
        sheetsViewModel: SheetsViewModel(),
        showNoteEditViewSheet: .constant(
            false
        ),
        showCategoriesSheet: .constant(false)
    )
}
