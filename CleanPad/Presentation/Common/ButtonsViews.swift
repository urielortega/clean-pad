//
//  ButtonsViews.swift
//  CleanPad
//
//  Created by Uriel Ortega on 29/09/23.
//

import Foundation
import SwiftUI

/// Button to show NoteEditView sheet.
struct CreateNoteButtonView: View {
    @Binding var showEditViewSheet: Bool
    
    var body: some View {
        Button {
            showEditViewSheet.toggle()
        } label: {
            Label("Create note", systemImage: "plus")
        }
    }
}
