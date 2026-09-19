//
//  DockView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 27/08/24.
//

import Foundation
import SwiftUI

/// Dock with buttons to show categories, create a new note and switch between the non-locked notes list and the locked notes list.
struct DockView: View {
    @Bindable var viewModel: MainScreenViewModel
    @ObservedObject var sheetsViewModel: SheetsViewModel
    @Binding var showNoteEditViewSheet: Bool
    @Binding var showCategoriesSheet: Bool
    
    /// Local State property for managing the creation of a new note.
    @State private var newNote = Note()

    /// Property to adapt the UI according to the available space.
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(NotesStore.self) private var notesStore
    @Environment(PrivateNotesAccessState.self) private var privateNotesAccess

    var body: some View {
        VStack {
            Spacer()
            
            dockControls
                .padding(
                    .horizontal,
                    (viewModel.idiom == .pad && sizeClass == .regular) ? 20 : 0
                )
        }
    }
}

/// A non-interactive light beam focused behind the tab bar glow area.
private struct DockTabBarGlowBeam: View {
    let color: Color
    let isVisible: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        LinearGradient(
            stops: [
                .init(color: color.opacity(Constants.dockGlowBeamTopOpacity), location: Constants.dockGlowBeamTopLocation),
                .init(color: color.opacity(middleOpacity), location: Constants.dockGlowBeamMiddleLocation),
                .init(color: color.opacity(bottomOpacity), location: Constants.dockGlowBeamBottomLocation)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(maxWidth: .infinity)
        .frame(height: Constants.dockGlowBeamHeight)
        .blur(radius: blurRadius)
        .blendMode(blendMode)
        .opacity(isVisible ? 1 : 0)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var middleOpacity: Double {
        colorScheme == .dark ? Constants.dockGlowBeamDarkModeMiddleOpacity : Constants.dockGlowBeamLightModeMiddleOpacity
    }

    private var bottomOpacity: Double {
        colorScheme == .dark ? Constants.dockGlowBeamDarkModeBottomOpacity : Constants.dockGlowBeamLightModeBottomOpacity
    }

    private var blurRadius: CGFloat {
        colorScheme == .dark ? Constants.dockGlowBeamDarkModeBlurRadius : Constants.dockGlowBeamLightModeBlurRadius
    }

    private var blendMode: BlendMode {
        colorScheme == .dark ? .screen : .normal
    }
}

// MARK: - Extension to group secondary views in DockView.

extension DockView {
    /// Decorative category-colored light beam used as tab bar glow feedback on iOS 26 and later.
    @ViewBuilder
    var tabBarGlowBeam: some View {
        if #available(iOS 26.0, *) {
            DockTabBarGlowBeam(
                color: viewModel.selectedCategory.color,
                isVisible: viewModel.isDockGlowing && viewModel.isSomeCategorySelected
            )
        }
    }

    /// Dock controls grouped in a Liquid Glass container on iOS 26 and later.
    ///
    /// The container lets the category button, tab bar, and create button participate in the same
    /// Liquid Glass rendering pass so their shapes can blend when they move close to each other.
    @ViewBuilder
    var dockControls: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: 10) {
                dockControlsContent
            }
        } else {
            dockControlsContent
        }
    }

    var dockControlsContent: some View {
        HStack {
            if viewModel.showingDockButtons(isPrivateAccessUnlocked: privateNotesAccess.isUnlocked) {
                showCategoriesDockButton
            }

            tabBar

            if viewModel.showingDockButtons(isPrivateAccessUnlocked: privateNotesAccess.isUnlocked) {
                createNoteDockButton
            }
        }
    }

    /// View that holds the nonLockedNotesTabButton and the lockedNotesTabButton with a Dock style.
    var tabBar: some View {
        HStack(spacing: 0) {
            nonLockedNotesTabButton
            lockedNotesTabButton
        }
        .overlay {
            CustomHStackDivider()
                .padding(.vertical)
                .allowsHitTesting(false)
        }
        .frame(height: 55)
        .dockStyle(
            viewModel: viewModel,
            isPrivateAccessUnlocked: privateNotesAccess.isUnlocked,
            isInteractive: true
        )
        .background(alignment: .bottom) {
            tabBarGlowBeam
        }
        .padding(.horizontal, viewModel.showingDockButtons(isPrivateAccessUnlocked: privateNotesAccess.isUnlocked) ? 0 : 10)
        .padding(
            .horizontal,
            (viewModel.idiom == .pad && sizeClass == .regular) ? 10 : 0
        )
    }
    
    /// Button for accessing the non-locked notes list.
    var nonLockedNotesTabButton: some View {
        Button {
            // Glow Dock when tapping nonLockedNotesTabButton and Non-Locked Notes Tab is selected:
            if viewModel.isNonLockedNotesTabSelected {
                withAnimation(.easeInOut(duration: 1)) {
                    viewModel.isDockGlowing.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 1)) {
                        viewModel.isDockGlowing.toggle()
                    }
                }
            }
            
            withAnimation(.bouncy) { viewModel.selectedTab = .nonLockedNotes }
            HapticManager.instance.impact(style: .soft)
        } label: {
            nonLockedNotesTabLabel
        }
    }
    
    /// Button for accessing the locked notes list.
    var lockedNotesTabButton: some View {
        Button {
            // Glow Dock when tapping lockedNotesTabButton and Locked Notes Tab is selected:
            if viewModel.isLockedNotesTabSelected {
                withAnimation(.easeInOut(duration: 1)) {
                    viewModel.isDockGlowing.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 1)) {
                        viewModel.isDockGlowing.toggle()
                    }
                }
            }
            
            withAnimation(.bouncy) { viewModel.selectedTab = .lockedNotes }
            HapticManager.instance.impact(style: .soft)
        } label: {
            lockedNotesTabLabel
        }
    }
    
    /// Label for nonLockedNotesTabButton.
    var nonLockedNotesTabLabel: some View {
        HStack {
            Spacer()
            
            Text("Notes")
                .padding(.bottom, 4)
                .tint(viewModel.isNonLockedNotesTabSelected ? .accentColor : .gray)
                .bold(viewModel.isNonLockedNotesTabSelected)
                .scaleEffect(viewModel.isNonLockedNotesTabSelected ? 1.0 : 0.9)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .contentShape(.rect)
        .accessibilityLabel("Your notes.")
    }
    
    /// Label for lockedNotesTabButton.
    var lockedNotesTabLabel: some View {
        HStack {
            Spacer()
            
            Text("Private")
                .padding(.bottom, 4)
                .tint(viewModel.isLockedNotesTabSelected ? .accentColor : .gray)
                .bold(viewModel.isLockedNotesTabSelected)
                .scaleEffect(viewModel.isLockedNotesTabSelected ? 1.0 : 0.9)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .contentShape(.rect)
        .accessibilityLabel("Your private notes.")
    }
    
    /// Button for creating a new note from the Dock.
    var createNoteDockButton: some View {
        Button { //                                             Non-locked note with General Category.     Locked note with General Category.
            newNote = viewModel.isNonLockedNotesTabSelected ? Note(category: notesStore.categories[0]) : Note(isLocked: true, category: notesStore.categories[0])
            
            showNoteEditViewSheet.toggle()
            HapticManager.instance.impact(style: .light)
        } label: {
            Label("New note", systemImage: "plus")
                .labelStyle(.iconOnly)
                .frame(width: 55, height: 55) // Frame on Label so tap is better detected.
                .contentShape(.rect(cornerRadius: Constants.roundedRectCornerRadius))
        }
        .dockButtonStyle(position: .right)
        .sheet(isPresented: $sheetsViewModel.showNoteEditViewSheet) {
            // Open NoteEditView with a new Note:
            NoteEditView(
                note: newNote,
                viewModel: viewModel,
                sheetsViewModel: sheetsViewModel,
                creatingNewNote: true
            )
            .interactiveDismissDisabled()
        }
    }
    
    /// Button for showing all user categories from the Dock.
    var showCategoriesDockButton: some View {
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
            .contentShape(.rect(cornerRadius: Constants.roundedRectCornerRadius))
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
