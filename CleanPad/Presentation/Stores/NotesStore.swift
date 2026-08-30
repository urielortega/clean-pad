//
//  NotesStore.swift
//  CleanPad
//
//  Created by Uriel Ortega on 21/08/26.
//

import Foundation
import Observation

/// Shared source of truth for user notes and categories.
///
/// `NotesStore` owns the in-memory note library, applies business rules that affect both notes and categories,
/// and persists changes through repository protocols.
@Observable
final class NotesStore {
    /// All notes currently loaded in memory.
    private(set) var notes: [Note] = []
    
    /// All user categories currently loaded in memory. Always falls back to `General`.
    private(set) var categories: [Category] = [.general]
    
    @ObservationIgnored private let notesRepository: NotesRepository
    @ObservationIgnored private let categoriesRepository: CategoriesRepository
    
    /// Category used when a note does not have an explicit category.
    var defaultCategory: Category {
        categories.first ?? .general
    }
    
    /// Creates a notes store backed by the provided repositories.
    init(
        notesRepository: NotesRepository = FileNotesRepository(),
        categoriesRepository: CategoriesRepository = FileCategoriesRepository()
    ) {
        self.notesRepository = notesRepository
        self.categoriesRepository = categoriesRepository
        loadData()
    }
}

extension NotesStore {
    // MARK: - Note CRUD functions.
    
    /// Adds a note and assigns the General category when no category is set.
    func add(note: Note) {
        var noteToSave = note
        noteToSave.category = note.category ?? defaultCategory
        notes.append(noteToSave)
        
        saveAllNotes()
    }
    
    /// Updates an existing note and optionally refreshes its modification date.
    func update(note: Note, updatingDate: Bool = true) {
        guard let index = getNoteIndexFromNotesArray(note: note) else { return }
        
        notes[index] = note
        
        if updatingDate {
            notes[index].date = .now
        }
        
        saveAllNotes()
    }
    
    /// Deletes a note from the current library.
    func delete(note: Note) {
        guard let index = getNoteIndexFromNotesArray(note: note) else { return }
        
        notes.remove(at: index)
        saveAllNotes()
    }
    
    /// Replaces the whole note collection, preserving persistence behavior.
    func replaceNotes(with notes: [Note]) {
        self.notes = notes
        saveAllNotes()
    }
    
    /// Toggles whether a note belongs to the private notes list.
    func toggleLockStatus(for note: Note) {
        guard let index = getNoteIndexFromNotesArray(note: note) else { return }
        
        notes[index].isLocked.toggle()
        saveAllNotes()
    }
    
    // MARK: - Category CRUD functions.
    
    /// Adds a category to the current category list.
    func add(category: Category) {
        categories.append(category)
        saveAllCategories()
    }
    
    /// Updates a category and propagates the new value to notes assigned to it.
    func update(category: Category) {
        guard let index = getCategoryIndexFromCategoriesArray(category: category) else { return }
        
        categories[index] = category
        updateNotesAssignedToCategory(category)
        
        saveAllCategories()
        saveAllNotes()
    }
    
    /// Deletes a category and moves affected notes back to General.
    func delete(category: Category) {
        guard let index = getCategoryIndexFromCategoriesArray(category: category) else { return }
        
        categories.remove(at: index)
        assignGeneralCategoryToNotesAssignedToCategory(category)
        
        saveAllCategories()
        saveAllNotes()
    }
    
    /// Removes every custom category and keeps only General.
    func dropAllCategories() {
        categories = [.general]
        saveAllCategories()
    }
    
    // MARK: - Persistence functions.
    
    /// Persists the current notes collection.
    func saveAllNotes() {
        do {
            try notesRepository.saveNotes(notes)
        } catch {
            print("Unable to save notes data.")
        }
    }
    
    /// Persists the current categories collection.
    func saveAllCategories() {
        do {
            try categoriesRepository.saveCategories(categories)
        } catch {
            print("Unable to save categories data.")
        }
    }
    
    /// Loads notes and categories from persistence, using empty/default fallbacks.
    func loadData() {
        do {
            notes = try notesRepository.loadNotes()
        } catch {
            notes = []
        }
        
        do {
            let loadedCategories = try categoriesRepository.loadCategories()
            categories = loadedCategories.isEmpty ? [.general] : loadedCategories
            
            setGeneralCategoryToUnassignedNotes()
        } catch {
            categories = [.general]
        }
    }
    
    // MARK: - Note retrieving functions.
    
    /// Returns the index for a note in the current collection.
    func getNoteIndexFromNotesArray(note: Note) -> Int? {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else {
            print("Couldn't find note in the 'notes' array.")
            return nil
        }
        
        return index
    }
    
    /// Returns the latest in-memory version of a note.
    func getNoteFromNotesArray(note: Note) -> Note? {
        guard let index = getNoteIndexFromNotesArray(note: note) else { return nil }
        
        return notes[index]
    }
    
    // MARK: - Category retrieving functions.
    
    /// Returns the index for a category in the current collection.
    func getCategoryIndexFromCategoriesArray(category: Category) -> Int? {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else {
            print("Couldn't find category in the 'categories' array.")
            return nil
        }
        
        return index
    }
    
    /// Returns the latest in-memory version of a category.
    func getCategoryFromCategoriesArray(category: Category) -> Category? {
        guard let index = getCategoryIndexFromCategoriesArray(category: category) else { return nil }
        
        return categories[index]
    }
    
    /// Checks whether a category exists in the current collection.
    func isCategoryInCategoriesArray(category: Category) -> Bool {
        categories.contains(category)
    }
    
    // MARK: - Business rules.
    
    /// Assigns General to notes loaded before categories existed.
    func setGeneralCategoryToUnassignedNotes() {
        for index in notes.indices {
            if notes[index].category == nil {
                notes[index].category = defaultCategory
            }
        }
    }
    
    /// Propagates a category update to every note assigned to that category.
    private func updateNotesAssignedToCategory(_ category: Category) {
        for index in notes.indices {
            if notes[index].category?.id == category.id {
                notes[index].category = category
            }
        }
    }
    
    /// Moves notes assigned to a deleted category back to General.
    private func assignGeneralCategoryToNotesAssignedToCategory(_ category: Category) {
        for index in notes.indices {
            if notes[index].category?.id == category.id {
                notes[index].category = defaultCategory
            }
        }
    }
}
