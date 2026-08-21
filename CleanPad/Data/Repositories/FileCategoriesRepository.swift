//
//  FileCategoriesRepository.swift
//  CleanPad
//
//  Created by Uriel Ortega on 21/08/26.
//

import Foundation

struct FileCategoriesRepository: CategoriesRepository {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        fileURL: URL = Constants.categoriesPath,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.fileURL = fileURL
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func loadCategories() throws -> [Category] {
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Category].self, from: data)
    }
    
    func saveCategories(_ categories: [Category]) throws {
        let data = try encoder.encode(categories)
        try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
    }
}
