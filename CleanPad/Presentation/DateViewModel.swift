//
//  DateViewModel.swift
//  CleanPad
//
//  Created by Uriel Ortega on 06/12/23.
//

import Foundation

/// ViewModel with date-related properties and functions.
final class DateViewModel: ObservableObject {
    /// Property to check today's date.
    @Published var today = Date()
    
    func getCurrentDateComponents() -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day], from: today)
    }
    
    func getDateComponents(for date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day], from: date)
    }
    
    func isNoteDateEqualToToday(note: Note) -> Bool {
        return getDateComponents(for: note.date) == getCurrentDateComponents()
    }
}
