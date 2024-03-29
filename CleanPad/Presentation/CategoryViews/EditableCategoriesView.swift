//
//  EditableCategoriesView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 18/03/24.
//

import SwiftUI

/// View that shows all user categories that can be edited by tapping one of them.
struct EditableCategoriesView: View {
    @ObservedObject var viewModel: NotesListViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List(viewModel.categories) { category in
                NavigationLink {
                    // TODO: Open CategoryEditView with the tapped category.
                    Text(category.name)
                } label: {
                    Text(category.name)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EditableCategoriesView(viewModel: NotesListViewModel())
}
