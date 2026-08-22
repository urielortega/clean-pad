//
//  NotesRepository.swift
//  CleanPad
//
//  Created by Uriel Ortega on 21/08/26.
//

import Foundation

/// Persistence boundary for notes.
///
/// `NotesStore` depends on this protocol instead of a concrete storage mechanism,
/// which keeps note business rules independent from file storage, SwiftData, or any
/// future persistence implementation.
protocol NotesRepository {
    /// Loads every persisted note from the current backing store.
    func loadNotes() throws -> [Note]
    
    /// Persists the complete notes collection as the new source of truth.
    func saveNotes(_ notes: [Note]) throws
}
