//
//  CategoriesRepository.swift
//  CleanPad
//
//  Created by Uriel Ortega on 21/08/26.
//

import Foundation

/// Persistence boundary for categories.
///
/// `NotesStore` depends on this protocol instead of a concrete storage mechanism,
/// which keeps category business rules independent from file storage, SwiftData, or
/// any future persistence implementation.
protocol CategoriesRepository {
    /// Loads every persisted category from the current backing store.
    func loadCategories() throws -> [Category]
    
    /// Persists the complete categories collection as the new source of truth.
    func saveCategories(_ categories: [Category]) throws
}
