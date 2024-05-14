//
//  CategoryEditView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 18/03/24.
//

import SwiftUI

/// View that shows all user categories that can be edited by tapping one of them.
struct CategoryEditView: View {
    @ObservedObject var viewModel: NotesListViewModel
    
    var body: some View {
        Text("I'm an Editable Category.")
    }
}

#Preview {
    CategoryEditView(viewModel: NotesListViewModel())
}
