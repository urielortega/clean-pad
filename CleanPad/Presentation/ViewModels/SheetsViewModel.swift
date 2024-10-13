//
//  SheetsViewModel.swift
//  CleanPad
//
//  Created by Uriel Ortega on 13/05/24.
//

import Foundation

/// ViewModel to control sheet displaying.
final class SheetsViewModel: ObservableObject {
    @Published var showWelcomeSheet = false
    @Published var showWhatsNewSheet = false
    @Published var showNoteEditViewSheet = false
    @Published var showFeedbackSheet = false
    @Published var showAboutSheet = false
    @Published var showCategorySelectionSheet = false
    @Published var showCategoryEditSheet = false
    @Published var showCategoryCreationSheet = false
    @Published var showNoteCategorySheet = false
}
