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
    
    /// Property to control access to locked notes (personal space).
    @Published private(set) var isUnlocked = false
    
    /// Property to control changes in notes.
    @Published private(set) var areChangesAllowed = false
    
    @Published private(set) var authenticationError = "Unknown error"
    @Published var isShowingAuthenticationError = false
    
    @Published var selectedTab: Tab = .nonLockedNotes
    var isNonLockedNotesTabSelected: Bool { selectedTab == .nonLockedNotes }
    var isLockedNotesTabSelected: Bool { selectedTab == .lockedNotes }
    
    /// Property to check if the system keyboard is shown.
    @Published var isKeyboardPresented = false
    
    /// Property to check today's date.
    @Published var today = Date()
    
    func getCurrentDateComponents() -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day], from: today)
    }
    
    func getDateComponents(for date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day], from: date)
    }
    
    func isNoteDateEqualToToday(note: Note) -> Bool {
        return getDateComponents(for: note.date) == getCurrentDateComponents()
    }
    
    var lockedNotes: [Note] {
        notes
            .sorted { $0.date > $1.date }
            .filter { $0.isLocked }
    }
    
    var nonLockedNotes: [Note] {
        notes
            .sorted { $0.date > $1.date }
            .filter { $0.isLocked == false }
    }
    
    var currentNotes: [Note] {
        if isLockedNotesTabSelected {
            lockedNotes
        } else {
            nonLockedNotes
        }
    }
    
    enum AuthenticationReason {
        case viewNotes, changeLockStatus
    }
    
    enum Tab {
        case nonLockedNotes, lockedNotes
    }
    
    /// Strings shown when a list is empty to invite the user to create a note.
    let placeholders = [
        "What's on your mind?",
        "How's been your day?",
        "How are you feeling right now?",
        "It's OK. Write it down.",
        "Make today a little bit better"
    ]
    
    /// Path used to store ``notes`` with documents directory.
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedNotes")
    
    init() {
        loadData()
    }
    
    /// Function responsible for loading user data with documents directory when launching app.
    func loadData() {
        do {
            let data = try Data(contentsOf: savePath)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            notes = []
        }
    }
    
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
    
    /// Function to authenticate with biometrics or passcode and allow access and changes to user notes.
    /// - Parameters:
    ///   - authenticationReason: Controls the flow involved in the modification of permissions.
    ///   - successAction: Closure called when authentication is successful.
    func authenticate(for authenticationReason: AuthenticationReason, successAction: @escaping () -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to lock and unlock your notes data." // Used for Touch ID
            
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
                        // Error.
                        self.authenticationError = "There was a problem authenticating you. Try again."
                        self.isShowingAuthenticationError = true
                    }
                }
            }
        } else {
            // No biometrics.
            authenticationError = "Sorry, your device does not support biometrics."
            isShowingAuthenticationError = true
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
    
    // CRUD functions
    
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
    
    /// Function to remove a locked note from the ``lockedNotes`` and ``notes`` array by using offsets.
    func removeLockedNoteFromList(at offsets: IndexSet) {
        var lockedNotes = notes.filter { $0.isLocked }
        lockedNotes.remove(atOffsets: offsets)
        notes = lockedNotes + notes.filter { $0.isLocked == false }
    }
    
    /// Function to remove a non-locked note from the ``nonLockedNotes`` and ``notes`` array by using offsets.
    func removeNonLockedNoteFromList(at offsets: IndexSet) {
        var nonLockedNotes = notes.filter { $0.isLocked == false }
        nonLockedNotes.remove(atOffsets: offsets)
        notes = nonLockedNotes + notes.filter { $0.isLocked }
    }
    
    /// Function to save existing notes with documents directory.
    func saveAllNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}
