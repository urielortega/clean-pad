//
//  LabelsViews.swift
//  CleanPad
//
//  Created by Uriel Ortega on 29/09/23.
//

import Foundation
import SwiftUI

struct NoteLabelView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
            Text(note.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
