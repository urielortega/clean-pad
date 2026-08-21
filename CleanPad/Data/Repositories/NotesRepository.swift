//
//  NotesRepository.swift
//  CleanPad
//
//  Created by Uriel Ortega on 21/08/26.
//

import Foundation

protocol NotesRepository {
    func loadNotes() throws -> [Note]
    func saveNotes(_ notes: [Note]) throws
}
