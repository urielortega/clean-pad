//
//  CategoriesRepository.swift
//  CleanPad
//
//  Created by Uriel Ortega on 21/08/26.
//

import Foundation

protocol CategoriesRepository {
    func loadCategories() throws -> [Category]
    func saveCategories(_ categories: [Category]) throws
}
