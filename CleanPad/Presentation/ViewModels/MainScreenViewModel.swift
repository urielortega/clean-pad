//
//  MainScreenViewModel.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import Foundation
import Observation
import SwiftUI

/// Presentation state and UI logic for the main notes list experience.
///
/// `MainScreenViewModel` does not own notes or categories. Persistent note data lives in
/// `NotesStore`; this type only decides how that data is filtered, sorted, selected, and presented.
@MainActor
@Observable
final class MainScreenViewModel {
    // MARK: Search properties.
    
    /// Text used to filter notes by title or content.
    var searchText = ""
    
    // MARK: Filtering and sorting properties.
    
    /// Category currently used to filter the notes list.
    ///
    /// `.noSelection` means all categories.
    var selectedCategory: Category = .noSelection
    
    /// Category currently being edited in the category sheet flow.
    var currentEditableCategory: Category = .noSelection
    
    /// Note currently being edited by presentation flows that need to keep a selected note reference.
    var currentEditableNote: Note?
    
    // MARK: Navigation and presentation properties.
    
    /// Selected notes tab: regular notes or private notes.
    var selectedTab: Constants.Tab = .nonLockedNotes
    var isNonLockedNotesTabSelected: Bool { selectedTab == .nonLockedNotes }
    var isLockedNotesTabSelected: Bool { selectedTab == .lockedNotes }
    
    /// Indicates whether dock side buttons can be shown for the current tab and private-note access state.
    func showingDockButtons(isPrivateAccessUnlocked: Bool) -> Bool {
        isNonLockedNotesTabSelected || (isLockedNotesTabSelected && isPrivateAccessUnlocked)
    }
    
    /// Persisted preference that controls whether notes are shown as a grid instead of a list.
    var isGridViewSelected = UserDefaults.standard.bool(forKey: "isGridViewSelected") {
        didSet {
            UserDefaults.standard.set(isGridViewSelected, forKey: "isGridViewSelected")
        }
    }
    
    /// Current device idiom used by views to adapt layout density.
    var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    /// Indicates whether the notes list is filtered by a specific category.
    var isSomeCategorySelected: Bool { selectedCategory != .noSelection }
    
    /// Indicates whether category selection is currently in edit mode.
    var isEditModeActive = false

    // MARK: Dock properties and functions.
    
    /// Controls the temporary glow animation shown after category selection.
    var isDockGlowing = false
    
}

// MARK: - ViewModel Methods:

extension MainScreenViewModel {
    // MARK: - Filtering and sorting
    
    /// Returns private notes from the provided collection.
    func lockedNotes(from notes: [Note]) -> [Note] {
        notes.filter { $0.isLocked }
    }
    
    /// Returns regular, non-private notes from the provided collection.
    func nonLockedNotes(from notes: [Note]) -> [Note] {
        notes.filter { $0.isLocked == false }
    }
    
    /// Returns private notes sorted from newest to oldest.
    func sortedByDateLockedNotes(from notes: [Note]) -> [Note] {
        lockedNotes(from: notes)
            .sorted { $0.date > $1.date }
    }
    
    /// Returns regular notes sorted from newest to oldest.
    func sortedByDateNonLockedNotes(from notes: [Note]) -> [Note] {
        nonLockedNotes(from: notes)
            .sorted { $0.date > $1.date }
    }
    
    /// Returns the notes that belong to the currently selected tab.
    func currentNotes(from notes: [Note]) -> [Note] {
        if isLockedNotesTabSelected {
            sortedByDateLockedNotes(from: notes)
        } else {
            sortedByDateNonLockedNotes(from: notes)
        }
    }
    
    /// Returns notes matching the selected tab, selected category, and search text.
    func filteredNotes(from notes: [Note]) -> [Note] {
        currentNotes(from: notes)
            .filter { note in
                selectedCategory == .noSelection || note.category?.id == selectedCategory.id
            }
            .filter { note in
                searchText.isEmpty ||
                    note.noteTitle.localizedStandardContains(searchText) ||
                    note.noteContent.localizedStandardContains(searchText)
            }
    }
    
    /// Removes notes from the active list using offsets produced by SwiftUI's list deletion.
    func removeNoteFromList(at offsets: IndexSet, in notesStore: NotesStore) {
        if isNonLockedNotesTabSelected {
            removeNonLockedNoteFromList(at: offsets, in: notesStore)
        } else {
            removeLockedNoteFromList(at: offsets, in: notesStore)
        }
    }
    
    /// Removes notes from the private-note projection and merges the remaining notes back into the store.
    private func removeLockedNoteFromList(at offsets: IndexSet, in notesStore: NotesStore) {
        var sortedLockedNotes = sortedByDateLockedNotes(from: notesStore.notes)
        sortedLockedNotes.remove(atOffsets: offsets)
        
        notesStore.replaceNotes(with: sortedLockedNotes + nonLockedNotes(from: notesStore.notes))
    }
    
    /// Removes notes from the regular-note projection and merges the remaining notes back into the store.
    private func removeNonLockedNoteFromList(at offsets: IndexSet, in notesStore: NotesStore) {
        var sortedNonLockedNotes = sortedByDateNonLockedNotes(from: notesStore.notes)
        sortedNonLockedNotes.remove(atOffsets: offsets)
        
        notesStore.replaceNotes(with: sortedNonLockedNotes + lockedNotes(from: notesStore.notes))
    }
    
    /// Indicates whether the provided category is the active category filter.
    func isCategorySelected(_ category: Category) -> Bool {
        selectedCategory == category
    }
    
    /// Selects the active category filter.
    func changeSelectedCategory(with category: Category) {
        selectedCategory = category
    }
    
    /// Stores the category currently being edited.
    func changeCurrentEditableCategory(with category: Category) {
        currentEditableCategory = category
    }
    
    /// Keeps the selected category filter synchronized after a category update.
    func handleUpdatedCategory(_ category: Category, in notesStore: NotesStore) {
        if currentEditableCategory == selectedCategory,
           let updatedCategory = notesStore.getCategoryFromCategoriesArray(category: category) {
            selectedCategory = updatedCategory
        }
    }
    
    /// Clears the selected category filter when that category was deleted.
    func handleDeletedCategory(_ category: Category) {
        if currentEditableCategory == selectedCategory {
            selectedCategory = .noSelection
        }
    }
    
    /// Triggers the dock glow animation used as category-selection feedback.
    func dockGlow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 1)) {
                self.isDockGlowing.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1)) {
                    self.isDockGlowing.toggle()
                }
            }
        }
    }
    
    #if DEBUG
    // MARK: - Testing functions.
    
    /// Adds twenty sample notes to the active tab for manual UI checks.
    func addTwentyNoteExamples(to notesStore: NotesStore) {
        if isLockedNotesTabSelected {
            for index in 1...20 {
                notesStore.add(note: Note(isLocked: true, noteTitle: String(index)))
            }
            notesStore.saveAllNotes()
        } else {
            for index in 1...20 {
                notesStore.add(note: Note(noteTitle: String(index)))
            }
            notesStore.saveAllNotes()
        }
    }
    
    /// Adds screenshot-oriented categories and notes for manual visual checks.
    func addScreenshotsNoteExamples(to notesStore: NotesStore) {
        // Adding the example categories (used in the Note.screenshotsExamples):
        for category in Category.screenshotsExamples {
            notesStore.add(category: category)
        }
        
        for note in Note.screenshotsExamples {
            notesStore.add(note: note)
        }
    }
    
    /// Adds one note assigned to a test category for category UI checks.
    func addTestNoteWithTestCategory(to notesStore: NotesStore) {
        let testCategory = Category(id: UUID(), name: "Test2", color: .green)
        
        notesStore.add(category: testCategory)
        notesStore.saveAllCategories()

        notesStore.add(
            note: Note(
                isLocked: false,
                noteTitle: "Test2 Category Note",
                noteContent: "New Category!",
                category: testCategory
            )
        )
        notesStore.saveAllNotes()
    }
    
    /// Adds one custom category for category UI checks.
    func addTestCategory(to notesStore: NotesStore) {
        let testCategory = Category(id: UUID(), name: "Test3", color: .pink)
        
        notesStore.add(category: testCategory)
        notesStore.saveAllCategories()
    }
    #endif
    
    /// Deletes every category except the General category.
    func dropAllCategories(in notesStore: NotesStore) {
        notesStore.dropAllCategories()
        print(notesStore.categories)
    }
}
