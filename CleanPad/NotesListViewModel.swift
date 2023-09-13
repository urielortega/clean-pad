//
//  NotesListViewModel.swift
//  CleanPad
//
//  Created by Uriel Ortega on 12/09/23.
//

import Foundation

class NotesListViewModel: ObservableObject {
    // Array containing all notes
    @Published private(set) var notes: [Note] = []
    
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
        // Loading data with documents directory:
        do {
            let data = try Data(contentsOf: savePath)
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            notes = [
                // Fill to test the List.
            ]
        }
    }
    
    // CRUD functions
    
    func add(note: Note) {
        notes.append(note)
        
        saveAllNotes()
    }
    
    func update(note: Note) {
        // To find the given note.
        guard let index = notes.firstIndex(where: {$0.id == note.id}) else {
            return
        }
        // Replace the original note with the updated one.
        notes[index] = note
        
        saveAllNotes()
    }
    
    func delete(note: Note) {
        // To find the given note.
        guard let index = notes.firstIndex(where: {$0.id == note.id}) else {
            return
        }
        notes.remove(at: index)
        
        saveAllNotes()
    }
    
    func saveAllNotes() {
        // Saving data with documents directory:
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print( "Unable to save data.")
        }
    }
}
