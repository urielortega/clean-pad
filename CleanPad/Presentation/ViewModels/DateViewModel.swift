//
//  DateViewModel.swift
//  CleanPad
//
//  Created by Uriel Ortega on 06/12/23.
//

import Foundation

/// ViewModel with date-related properties and functions.
final class DateViewModel: ObservableObject {
    func isNoteDateEqualToToday(note: Note) -> Bool {
        Calendar.current.isDate(note.date, inSameDayAs: .now)
    }
}
