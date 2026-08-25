//
//  FileCategoriesRepository.swift
//  CleanPad
//
//  Created by Uriel Ortega on 21/08/26.
//

import Foundation

/// File-backed implementation of `CategoriesRepository`.
///
/// Categories are encoded as JSON and stored at `Constants.categoriesPath` by
/// default. The initializer accepts dependencies so previews, tests, or migrations
/// can use a different file URL or custom coders without changing `NotesStore`.
struct FileCategoriesRepository: CategoriesRepository {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    /// Creates a repository that reads and writes categories from a JSON file.
    init(
        fileURL: URL = Constants.categoriesPath,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileURL = fileURL
        self.encoder = encoder
        self.decoder = decoder
    }
    
    /// Decodes all categories from the configured file URL.
    func loadCategories() throws -> [Category] {
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Category].self, from: data)
    }
    
    /// Encodes and writes all categories using an atomic, file-protected write.
    func saveCategories(_ categories: [Category]) throws {
        let data = try encoder.encode(categories)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
}
