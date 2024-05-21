//
//  CategoryEditView.swift
//  CleanPad
//
//  Created by Uriel Ortega on 18/03/24.
//

import SwiftUI

/// View that shows all user categories that can be edited by tapping one of them.
struct CategoryEditView: View {
    @State var category: Category
    
    @ObservedObject var viewModel: NotesListViewModel
    
    /// Property to show Cancel and Save buttons, and handle `onChange` closures.
    var creatingNewCategory: Bool
    
    @Environment(\.dismiss) var dismiss
    
    /// Property to adapt the UI for VoiceOver users.
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
        
    var body: some View {
        Group {
            if creatingNewCategory {
                Text("I'm about to be a new category!")
            } else {
                Text("I'm an editable category called \(category.name)")
            }
        }
        .foregroundStyle(category.color)
    }
}

#Preview {
    CategoryEditView(
        category: .example,
        viewModel: NotesListViewModel(),
        creatingNewCategory: false
    )
}
