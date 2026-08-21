//
//  FileNotesRepository.swift
//  CleanPad
//
//  Created by Uriel Ortega on 21/08/26.
//

import Foundation

struct FileNotesRepository: NotesRepository {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        fileURL: URL = Constants.savePath,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileURL = fileURL
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func loadNotes() throws -> [Note] {
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Note].self, from: data)
    }
    
    func saveNotes(_ notes: [Note]) throws {
        let data = try encoder.encode(notes)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
}
