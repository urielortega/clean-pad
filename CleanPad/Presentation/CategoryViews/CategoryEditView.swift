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
            VStack {
                CustomTopTitle(
                    text: creatingNewCategory ? "Create New Category" : "Update Category"
                )
                .padding([.horizontal, .top])
                
                HStack {
                    categoryNameTextField
                    
                    categoryColorPicker
                        .padding(.leading)
                }
                .padding()
                .padding(.trailing)
                
                Spacer()
            }
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
        .presentationBackground(.regularMaterial)
    }
    
    var categoryNameTextField: some View {
        TextField( "Name your category...", text: $category.name)
            .textFieldStyle(
                GradientTextFieldStyle(
                    startColor: .gridLabelBackground.opacity(0.8),
                    endColor: category.color
                )
            )
    }
    
    var categoryColorPicker: some View {
        ColorPicker(
            "Set the category color",
            selection: $category.color,
            supportsOpacity: false
        )
        .labelsHidden()
    }
}

#Preview {
    CategoryEditView(
        category: .example,
        viewModel: NotesListViewModel(),
        creatingNewCategory: false
    )
}
