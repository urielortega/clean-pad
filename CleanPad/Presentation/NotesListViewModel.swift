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
    // Array containing all notes
    @Published private(set) var notes: [Note] = []
    
    @Published private(set) var isUnlocked = false
    @Published private(set) var areChangesAllowed = false // Property to control changes in notes.
    
    @Published private(set) var authenticationError = "Unknown error"
    @Published var isShowingAuthenticationError = false
    
    var lockedNotes: [Note] {
        notes.filter { $0.isLocked }
    }
    
    var nonLockedNotes: [Note] {
        notes.filter { $0.isLocked == false }
    }
    
    enum AuthenticationReason {
        case viewNotes, changeLockStatus
    }
    
    let placeholders = [
        "What's on your mind?",
        "How's been your day?",
        "How are you feeling right now?",
        "It's OK. Write it down.",
        "It's nice to see you here.",
        "Make today a little bit better"
    ]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedNotes")
    
    init() {
        loadData()
    }
    
    func loadData() {
        // Loading data with documents directory:
        do {
            let data = try Data(contentsOf: savePath)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            notes = []
        }
    }
    
    func getNoteIndexFromNotesArray(note: Note) -> Int? {
        // To find the given note.
        guard let index = self.notes.firstIndex(where: {$0.id == note.id}) else {
            print("Couldn't find note in the 'notes' array.")
            return nil
        }
        
        return index
    }
    
    func getNoteFromNotesArray(note: Note) -> Note? {
        let index = getNoteIndexFromNotesArray(note: note)!
        
        return self.notes[index]
    }
    
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
    
    func add(note: Note) {
        notes.append(note)
        saveAllNotes()
    }
    
    func update(note: Note) {
        let index = self.getNoteIndexFromNotesArray(note: note)!
        
        // Replace the original note with the updated one:
        notes[index] = note
        
        // Update note date.
        notes[index].date = .now
        
        saveAllNotes()
    }
    
    func delete(note: Note) {
        let index = self.getNoteIndexFromNotesArray(note: note)!
        notes.remove(at: index)
        saveAllNotes()
    }
    
    func removeLockedNoteFromList(at offsets: IndexSet) {
        var lockedNotes = notes.filter { $0.isLocked }
        lockedNotes.remove(atOffsets: offsets)
        notes = lockedNotes + notes.filter { $0.isLocked == false }
    }
    
    func removeNonLockedNoteFromList(at offsets: IndexSet) {
        var nonLockedNotes = notes.filter { $0.isLocked == false }
        nonLockedNotes.remove(atOffsets: offsets)
        notes = nonLockedNotes + notes.filter { $0.isLocked }
    }
    
    func saveAllNotes() {
        // Saving data with documents directory:
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}
