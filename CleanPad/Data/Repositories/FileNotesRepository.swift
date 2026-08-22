//
//  FileNotesRepository.swift
//  CleanPad
//
//  Created by Uriel Ortega on 21/08/26.
//

import Foundation

/// File-backed implementation of `NotesRepository`.
///
/// Notes are encoded as JSON and stored at `Constants.savePath` by default. The
/// initializer accepts dependencies so previews, tests, or migrations can use a
/// different file URL or custom coders without changing `NotesStore`.
struct FileNotesRepository: NotesRepository {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    /// Creates a repository that reads and writes notes from a JSON file.
    init(
        fileURL: URL = Constants.savePath,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileURL = fileURL
        self.encoder = encoder
        self.decoder = decoder
    }
    
    /// Decodes all notes from the configured file URL.
    func loadNotes() throws -> [Note] {
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Note].self, from: data)
    }
    
    /// Encodes and writes all notes using an atomic, file-protected write.
    func saveNotes(_ notes: [Note]) throws {
        let data = try encoder.encode(notes)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
}
