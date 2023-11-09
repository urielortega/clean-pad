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

/// Button to definitely delete a note, with optional view dismissal.
struct deleteNoteButton: View {
    var note: Note
    @ObservedObject var viewModel: NotesListViewModel
    var dismissView: Bool

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(role: .destructive) {
            if dismissView {
                dismiss()
                
                // Delete note after delay.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation {
                        viewModel.delete(note: note)
                    }
                }
            } else {
                withAnimation {
                    viewModel.delete(note: note)
                }
            }
        } label: {
            Label("Delete note", systemImage: "trash.fill")
        }
    }
}
