//
//  NotesListViewModel.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import Foundation
import LocalAuthentication
import SwiftUI

final class NotesListViewModel: ObservableObject {
    /// Array saved in documents directory containing all user notes.
    @Published private(set) var notes: [Note] = []
    
    /// Array saved in documents directory containing note categories.
    @Published private(set) var categories: [Category] = [.general]
        
    // MARK: Search properties.
    @Published var searchText = ""
    
    // MARK: Filtering and sorting properties.
    var lockedNotes: [Note] {
        notes.filter { $0.isLocked }
    }
    
    var nonLockedNotes: [Note] {
        notes.filter { $0.isLocked == false }
    }
    
    var sortedByDateLockedNotes: [Note] {
        lockedNotes
            .sorted { $0.date > $1.date }
    }
    
    var sortedByDateNonLockedNotes: [Note] {
        nonLockedNotes
            .sorted { $0.date > $1.date }
    }
    
    @Published var selectedCategory: Category = .noSelection
    @Published var currentEditableCategory: Category = .noSelection
    @Published var currentEditableNote: Note?
    
    /// Computed property that returns a Note array with all notes or the ones resulting from a search.
    var filteredNotes: [Note] {
        currentNotes
            .filter { note in
                // If selectedCategory is .noSelection...
                // ...the condition will always be true...
                // ...so all notes will pass the filter.
                                                // If a specific category is selected
                                                // ...only the notes with that category will pass the filter.
                selectedCategory == .noSelection || note.category?.id == selectedCategory.id
            }
            .filter { note in
                // If the user hasn't entered any text...
                // then the condition will always be true
                // ...and all the remaining notes will pass this filter.
                searchText.isEmpty ||
                // If the search text is not empty, we proceed to the next conditions:
                
                    // If the noteTitle contains the search text...
                    // ...this condition will return true for that note, and it will pass the filter.
                    note.noteTitle.localizedStandardContains(searchText) ||
                    // If either the title or content contains the search text, the note will pass this filter.
                    note.noteContent.localizedStandardContains(searchText)
            }
    }
        
    // MARK: Navigation and presentation properties.
    @Published var selectedTab: Constants.Tab = .nonLockedNotes
    var isNonLockedNotesTabSelected: Bool { selectedTab == .nonLockedNotes }
    var isLockedNotesTabSelected: Bool { selectedTab == .lockedNotes }
    
    var currentNotes: [Note] {
        if isLockedNotesTabSelected {
            sortedByDateLockedNotes
        } else {
            sortedByDateNonLockedNotes
        }
    }
    
    var showingDockButtons: Bool {
        // Dock Buttons are shown only when the Non-Locked Notes Tab is selected...
        // ...or the Locked Notes Tab is selected and access to it is granted.
        isNonLockedNotesTabSelected || (isLockedNotesTabSelected && isUnlocked)
    }
    
    @AppStorage("isGridViewSelected") var isGridViewSelected = false
    
    var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var isSomeCategorySelected: Bool { selectedCategory != .noSelection }
    
    func isCategorySelected(_ category: Category) -> Bool {
        return selectedCategory == category
    }
    
    /// Property to control the status of Category Edit Mode.
    @Published var isEditModeActive = false

    // MARK: Dock properties and functions.
    @Published var isDockGlowing = false
    
    /// Function to trigger delayed Dock Glow.
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
        
    // MARK: Access control properties.
    /// Property to control access to locked notes (private space).
    @Published var isUnlocked = false
    
    /// Property to control changes in notes.
    @Published private(set) var areChangesAllowed = false
    
    @Published private(set) var authenticationError = "Unknown error"
    @Published var isShowingAuthenticationErrorOnMainScreen = false
    @Published var isShowingAuthenticationErrorWhenEditing = false
    
    init() {
        loadData()
    }
}

/// ViewModel functions:
extension NotesListViewModel {
    // MARK: Note CRUD functions.
    /// Function to add a note to the ``notes`` array and save the changes after the addition.
    /// - Parameter note: A  new ``Note`` object to be added to the ``notes`` array.
    func add(note: Note) {
        withAnimation {
            if note.category == nil { // If 'note' has no category assigned...
                let noteToAssignCategory = Note(
                    isLocked: note.isLocked,
                    noteTitle: note.noteTitle,
                    noteContent: note.noteContent,
                    category: categories[0] // ..assign General category from 'categories' array.
                )
                
                notes.append(noteToAssignCategory)
            } else {
                notes.append(note)
            }
            
            saveAllNotes()
        }
    }
    
    /// Function to update a note and save the changes in the ``notes`` array.
    /// - Parameter note: An existing ``Note`` object to be updated in the ``notes`` array.
    func update(note: Note, updatingDate: Bool = true) {
        withAnimation {
            if let index = self.getNoteIndexFromNotesArray(note: note) {
                
                // Replace the original note with the updated one:
                notes[index] = note
                
                // Update note date:
                if updatingDate { notes[index].date = .now }
                
                saveAllNotes()
            }
        }
    }
    
    /// Function to delete a note and save the changes in the ``notes`` array.
    /// - Parameter note: An existing ``Note`` object to be deleted from the ``notes`` array.
    func delete(note: Note) {
        let index = self.getNoteIndexFromNotesArray(note: note)!
        notes.remove(at: index)
        saveAllNotes()
    }
    
    /// Function to remove a locked note from the ``notes`` array by using offsets.
    func removeLockedNoteFromList(at offsets: IndexSet) {
        // Array used to locate and remove a specific note using offsets.
        var sortedLockedNotes = sortedByDateLockedNotes
        sortedLockedNotes.remove(atOffsets: offsets)
        
        // Merging the notes shown in the List and the rest of the notes (nonLockedNotes).
        notes = sortedLockedNotes + nonLockedNotes
        
        saveAllNotes()
    }
    
    /// Function to remove a non-locked note from the ``notes`` array by using offsets.
    func removeNonLockedNoteFromList(at offsets: IndexSet) {
        // Array used to locate and remove a specific note using offsets.
        var sortedNonLockedNotes = sortedByDateNonLockedNotes
        sortedNonLockedNotes.remove(atOffsets: offsets)
        
        // Merging the notes shown in the List and the rest of the notes (lockedNotes).
        notes = sortedNonLockedNotes + lockedNotes
        
        saveAllNotes()
    }

    func removeNoteFromList(at offsets: IndexSet) {
        if isNonLockedNotesTabSelected {
            removeNonLockedNoteFromList(at: offsets)
        } else {
            removeLockedNoteFromList(at: offsets)
        }
    }
    
    /// Function to save existing notes with documents directory.
    func saveAllNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: Constants.savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    // MARK: Category CRUD functions.
    /// Function to add a category to the ``categories`` array and save the changes after the addition.
    /// - Parameter category: A  new ``Category`` object to be added to the ``categories`` array.
    func add(category: Category) {
        categories.append(category)
        saveAllCategories()
    }
    
    /// Function to update a category and save the changes in the ``categories`` array.
    /// - Parameter category: An existing ``Category`` object to be updated in the ``categories`` array.
    func update(category: Category) {
        let index = self.getCategoryIndexFromCategoriesArray(category: category)!
        
        // Replace the original category with the updated one:
        categories[index] = category
        
        if currentEditableCategory == selectedCategory {
            // Assign the updated category to selectedCategory.
            selectedCategory = categories[index]
        }
        
        // Update notes that have this category assigned.
        for index in 0..<notes.count {
            if notes[index].category?.id == category.id {
                notes[index].category = category
            }
        }
        
        saveAllCategories()
        saveAllNotes()
    }
    
    /// Function to delete a category and save the changes in the ``categories`` array.
    /// - Parameter category: An existing ``Category`` object to be deleted from the ``categories`` array.
    func delete(category: Category) {
        let index = self.getCategoryIndexFromCategoriesArray(category: category)!
        categories.remove(at: index)
        
        if currentEditableCategory == selectedCategory {
            // No Category selected when deleting the selectedCategory.
            selectedCategory = .noSelection
        }
        
        // Assign General category to notes that have this category assigned.
        for index in 0..<notes.count {
            if notes[index].category?.id == category.id {
                notes[index].category = categories[0] // Assigning General category from 'categories' array.
            }
        }
        
        saveAllCategories()
        saveAllNotes()
    }
    
    /// Function to save existing categories with documents directory.
    func saveAllCategories() {
        do {
            let data = try JSONEncoder().encode(categories)
            try data.write(to: Constants.categoriesPath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    /// Function to change the value of the selectedCategory property.
    func changeSelectedCategory(with category: Category) {
        selectedCategory = category
    }
    
    /// Function to change the value of the currentEditableCategory property.
    func changeCurrentEditableCategory(with category: Category) {
        currentEditableCategory = category
    }
    
    // MARK: Data loading functions.
    /// Function responsible for loading user data with documents directory when launching app.
    func loadData() {
        do {
            // Loading notes data:
            let data = try Data(contentsOf: Constants.savePath)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            notes = []
        }
        
        do {
            // Loading categories data:
            let categoriesData = try Data(contentsOf: Constants.categoriesPath)
            categories = try JSONDecoder().decode([Category].self, from: categoriesData)
            
            setGeneralCategoryToUnassignedNotes()
        } catch {
            categories = [.general]
        }
    }
    
    /// Function that sets General category to notes that are currently unassigned to any category.
    func setGeneralCategoryToUnassignedNotes() {
        for index in notes.indices {
            if notes[index].category == nil {
                notes[index].category = categories[0] // Using General category from 'categories' array.
            }
        }
    }
    
    // MARK: Access control functions.
    /// Function to authenticate with biometrics or passcode and allow access and changes to user notes.
    /// - Parameters:
    ///   - authenticationReason: Controls the flow involved in the modification of permissions.
    ///   - successAction: Closure called when authentication is successful.
    func authenticate(for authenticationReason: Constants.AuthenticationReason, successAction: @escaping () -> Void) {
        let context = LAContext()
        var error: NSError?
        let reason = "Please authenticate yourself to lock and unlock your notes data." // Used for Touch ID.
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Error handling for devices without biometrics.
            authenticationError = "Sorry, your device does not support biometrics."
            
            if authenticationReason == .viewNotes {
                isShowingAuthenticationErrorOnMainScreen = true
            } else if authenticationReason == .changeLockStatus {
                isShowingAuthenticationErrorWhenEditing = true
            }
            
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            Task { @MainActor in
                if success {
                    withAnimation(.bouncy) {
                        if authenticationReason == .viewNotes {
                            self.isUnlocked = true
                        } else if authenticationReason == .changeLockStatus {
                            self.areChangesAllowed = true
                        }
                        successAction()
                    }
                } else {
                    // Error handling for authentication failure.
                    let errorDescription: String
                    
                    switch authenticationError {
                    case LAError.authenticationFailed?:
                        errorDescription = "Authentication failed. Please try again."
                    case LAError.userCancel?, LAError.userFallback?:
                        errorDescription = "Authentication canceled."
                    case LAError.biometryNotAvailable?, LAError.biometryNotEnrolled?:
                        errorDescription = "Biometrics not available or not enrolled. Use passcode instead."
                    default:
                        errorDescription = "Authentication error. Try again later."
                    }
                    
                    self.authenticationError = errorDescription
                    
                    if authenticationReason == .viewNotes {
                        self.isShowingAuthenticationErrorOnMainScreen = true
                    } else if authenticationReason == .changeLockStatus {
                        self.isShowingAuthenticationErrorWhenEditing = true
                    }
                }
            }
        }
    }

    /// Function to change the `isLocked` property of a ``Note`` object.
    /// - Parameter note: A ``Note`` object, whose `isLocked` property changes if authentication is successful.
    func updateLockStatus(for note: Note) {
        authenticate(for: .changeLockStatus) {
            let index = self.getNoteIndexFromNotesArray(note: note)!
            
            // Update isLocked property.
            self.notes[index].isLocked.toggle()
            
            self.saveAllNotes()
            
            self.forbidChanges()
        }
    }
    
    func lockNotes() {
        isUnlocked = false
    }
    
    func forbidChanges() {
        areChangesAllowed = false
    }
    
    // MARK: Note retrieving functions.
    /// Function to retrieve a note index from the global ``notes`` array.
    /// - Parameter note: A ``Note`` object that might be in the ``notes`` array.
    /// - Returns: An Integer index representing the position of the note in the ``notes`` array.
    func getNoteIndexFromNotesArray(note: Note) -> Int? {
        // To find the given note.
        guard let index = self.notes.firstIndex(where: {$0.id == note.id}) else {
            print("Couldn't find note in the 'notes' array.")
            return nil
        }
        
        return index
    }
    
    /// Function to retrieve a note from the global ``notes`` array.
    /// - Parameter note: A ``Note`` object that might be in the ``notes`` array.
    /// - Returns: A ``Note`` object, found in the ``notes`` array, with up to date data.
    func getNoteFromNotesArray(note: Note) -> Note? {
        let index = getNoteIndexFromNotesArray(note: note)!
        
        return self.notes[index]
    }
    
    // MARK: Category retrieving functions.
    /// Function to retrieve a category index from the global ``categories`` array.
    /// - Parameter category: A ``Category`` object that might be in the ``categories`` array.
    /// - Returns: An Integer index representing the position of the category in the ``categories`` array.
    func getCategoryIndexFromCategoriesArray(category: Category) -> Int? {
        // To find the given category.
        guard let index = self.categories.firstIndex(where: {$0.id == category.id}) else {
            print("Couldn't find category in the 'categories' array.")
            return nil
        }
        
        return index
    }
    
    /// Function to retrieve a note from the global ``categories`` array.
    /// - Parameter category: A ``Category`` object that might be in the ``categories`` array.
    /// - Returns: A ``Category`` object, found in the ``categories`` array, with up to date data.
    func getCategoryFromCategoriesArray(category: Category) -> Category? {
        let index = getCategoryIndexFromCategoriesArray(category: category)!
        
        return self.categories[index]
    }
    
    func isCategoryInCategoriesArray(category: Category) -> Bool {
        categories.contains(category)
    }
    
    #if DEBUG
    // MARK: Testing functions.
    /// Function for testing purposes that adds twenty note examples to the ``notes`` array and saves the changes after the addition.
    func addTwentyNoteExamples() {
        if isLockedNotesTabSelected {
            for index in 1...20 {
                add(note: Note(isLocked: true, noteTitle: String(index)))
            }
            saveAllNotes()
        } else {
            for index in 1...20 {
                add(note: Note(noteTitle: String(index)))
            }
            saveAllNotes()
        }
    }
    
    /// Function for testing purposes that adds ten note examples to the ``notes`` array and saves the changes after the addition.
    func addScreenshotsNoteExamples() {
        // Adding the example categories (used in the Note.screenshotsExamples):
        for category in Category.screenshotsExamples {
            add(category: category)
        }
        
        for note in Note.screenshotsExamples {
            add(note: note)
        }
    }
    
    func addTestNoteWithTestCategory() {
        let testCategory = Category(id: UUID(), name: "Test2", color: .green)
        
        add(category: testCategory)
        saveAllCategories()

        add(
            note: Note(
                isLocked: false,
                noteTitle: "Test2 Category Note",
                noteContent: "New Category!",
                category: testCategory
            )
        )
        saveAllNotes()
    }
    
    func addTestCategory() {
        let testCategory = Category(id: UUID(), name: "Test3", color: .pink)
        
        add(category: testCategory)
        saveAllCategories()
    }
    #endif
    
    // Deletes every category except the General category.
    func dropAllCategories() {
        categories = [.general]
        saveAllCategories()
        print(categories)
    }
}
