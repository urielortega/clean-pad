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
    
    /// Computed property that returns a Note array with all notes or the ones resulting from a search.
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return currentNotes // Locked or non-locked notes, sorted by date.
        } else {
            return currentNotes
                .filter { // Returns notes that match the search field with its title or content.
                    $0.noteTitle.localizedCaseInsensitiveContains(searchText) || $0.noteContent.localizedCaseInsensitiveContains(searchText)
                }
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
    
    @AppStorage("isGridViewSelected") var isGridViewSelected = false
    
    var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    // MARK: Access control properties.
    /// Property to control access to locked notes (private space).
    @Published private(set) var isUnlocked = false
    
    /// Property to control changes in notes.
    @Published private(set) var areChangesAllowed = false
    
    @Published private(set) var authenticationError = "Unknown error"
    @Published var isShowingAuthenticationError = false
    
    init() {        
        loadData()
    }
}

/// ViewModel functions:
extension NotesListViewModel {
    // MARK: CRUD functions.
    /// Function to add a note to the ``notes`` array and save the changes after the addition.
    /// - Parameter note: A  new ``Note`` object to be added to the ``notes`` array.
    func add(note: Note) {
        notes.append(note)
        saveAllNotes()
    }
    
    /// Function to update a note and save the changes in the ``notes`` array.
    /// - Parameter note: An existing ``Note`` object to be updated in the ``notes`` array.
    func update(note: Note) {
        let index = self.getNoteIndexFromNotesArray(note: note)!
        
        // Replace the original note with the updated one:
        notes[index] = note
        
        // Update note date.
        notes[index].date = .now
        
        saveAllNotes()
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
    
    // MARK: Data loading functions.
    /// Function responsible for loading user data with documents directory when launching app.
    func loadData() {
        do {
            let data = try Data(contentsOf: Constants.savePath)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            notes = []
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
            isShowingAuthenticationError = true
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            Task { @MainActor in
                if success {
                    if authenticationReason == .viewNotes {
                        self.isUnlocked = true
                    } else if authenticationReason == .changeLockStatus {
                        self.areChangesAllowed = true
                    }
                    successAction()
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
                    self.isShowingAuthenticationError = true
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
        for note in Note.screenshotsExamples {
            add(note: note)
        }
    }
}
