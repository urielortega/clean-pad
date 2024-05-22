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
        NavigationStack {
            HStack {
                TextField(
                    "Name your category...",
                    text: $category.name
                )
                .padding()
                
                ColorPicker(
                    "Set the category color", 
                    selection: $category.color,
                    supportsOpacity: false
                )
                .labelsHidden()
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        creatingNewCategory ? "Save" : "Update"
                    ) { dismiss() }
                }
            }
        }
        .presentationBackground(.thinMaterial)
    }
}

#Preview {
    CategoryEditView(
        category: .example,
        viewModel: NotesListViewModel(),
        creatingNewCategory: false
    )
}
