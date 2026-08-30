//
//  Date+Helpers.swift
//  CleanPad
//
//  Created by Uriel Ortega on 30/08/26.
//

import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.isDate(self, inSameDayAs: .now)
    }
}
