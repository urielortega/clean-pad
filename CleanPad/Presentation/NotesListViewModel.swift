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
                // Uncomment to test the List:
                Note(
                    isLocked: true,
                    title: "Test for a new note 1",
                    textContent:
                    """
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer faucibus hendrerit facilisis. In sit amet magna neque. Morbi tortor risus, volutpat non tristique ac, faucibus vitae sem. Curabitur gravida leo non dui sagittis bibendum. Aliquam commodo mi sed posuere fringilla. Cras sagittis libero at bibendum pulvinar. Maecenas eget lorem id ipsum efficitur pharetra sit amet at ipsum.

                    Sed vitae libero facilisis, efficitur risus eu, mattis sem.

                    Mauris bibendum porta mi, in consectetur sem iaculis eget. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nam commodo venenatis mi, mattis laoreet enim varius et. Maecenas mauris neque, consequat vel elementum sollicitudin, sagittis ac velit. Nam finibus lorem tortor. Praesent metus nunc, pharetra non bibendum scelerisque, vehicula vel libero. Fusce metus nulla, scelerisque a facilisis rhoncus, auctor id mi. Duis porttitor vel lectus et fringilla. Proin suscipit quis tortor non aliquam. Etiam feugiat, mauris quis viverra pharetra, libero ante dignissim orci, et feugiat augue mauris eu lacus. Integer malesuada ante metus, at gravida ex ullamcorper fermentum. Sed dui lectus, pellentesque ac porttitor sit amet, aliquet sed metus. Aenean bibendum eget ipsum et ullamcorper.
                    """
                ),
                Note(
                    title: "Test for a new note 2",
                    textContent: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer faucibus hendrerit facilisis."
                ),
                Note(
                    title: "Test for a new note 3",
                    textContent: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
                )
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
    
    func removeLockedNoteFromList(at offsets: IndexSet) {
        var lockedNotes = notes.filter { $0.isLocked }
        
        lockedNotes.remove(atOffsets: offsets)
        
        notes = lockedNotes + notes.filter {
            $0.isLocked == false
        }
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
            print( "Unable to save data.")
        }
    }
}
